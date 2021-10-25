locals {
  enabled = module.this.enabled

  bootstrap_brokers               = try(aws_msk_cluster.default[0].bootstrap_brokers, "")
  bootstrap_brokers_list          = local.bootstrap_brokers != "" ? sort(split(",", local.bootstrap_brokers)) : []
  bootstrap_brokers_tls           = try(aws_msk_cluster.default[0].bootstrap_brokers_tls, "")
  bootstrap_brokers_tls_list      = local.bootstrap_brokers_tls != "" ? sort(split(",", local.bootstrap_brokers_tls)) : []
  bootstrap_brokers_scram         = try(aws_msk_cluster.default[0].bootstrap_brokers_sasl_scram, "")
  bootstrap_brokers_scram_list    = local.bootstrap_brokers_scram != "" ? sort(split(",", local.bootstrap_brokers_scram)) : []
  bootstrap_brokers_iam           = try(aws_msk_cluster.default[0].bootstrap_brokers_sasl_iam, "")
  bootstrap_brokers_iam_list      = local.bootstrap_brokers_iam != "" ? sort(split(",", local.bootstrap_brokers_iam)) : []
  bootstrap_brokers_combined_list = concat(local.bootstrap_brokers_list, local.bootstrap_brokers_tls_list, local.bootstrap_brokers_scram_list, local.bootstrap_brokers_iam_list)
  # If var.storage_autoscaling_max_capacity is not set, don't autoscale past current size
  broker_volume_size_max = coalesce(var.storage_autoscaling_max_capacity, var.broker_volume_size)
}

resource "aws_security_group" "default" {
  count       = local.enabled ? 1 : 0
  vpc_id      = var.vpc_id
  name        = module.this.id
  description = "Allow inbound traffic from Security Groups and CIDRs. Allow all outbound traffic"
  tags        = module.this.tags
}

resource "aws_security_group_rule" "ingress_security_groups" {
  count                    = local.enabled ? length(var.security_groups) : 0
  description              = "Allow inbound traffic from Security Groups"
  type                     = "ingress"
  from_port                = 0
  to_port                  = 65535
  protocol                 = "tcp"
  source_security_group_id = var.security_groups[count.index]
  security_group_id        = join("", aws_security_group.default.*.id)
}

resource "aws_security_group_rule" "ingress_cidr_blocks" {
  count             = local.enabled && length(var.allowed_cidr_blocks) > 0 ? 1 : 0
  description       = "Allow inbound traffic from CIDR blocks"
  type              = "ingress"
  from_port         = 0
  to_port           = 65535
  protocol          = "tcp"
  cidr_blocks       = var.allowed_cidr_blocks
  security_group_id = join("", aws_security_group.default.*.id)
}

resource "aws_security_group_rule" "egress" {
  count             = local.enabled ? 1 : 0
  description       = "Allow all egress traffic"
  type              = "egress"
  from_port         = 0
  to_port           = 65535
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = join("", aws_security_group.default.*.id)
}

resource "aws_msk_configuration" "config" {
  count          = local.enabled ? 1 : 0
  kafka_versions = [var.kafka_version]
  name           = module.this.id
  description    = "Manages an Amazon Managed Streaming for Kafka configuration"

  server_properties = join("\n", [for k in keys(var.properties) : format("%s = %s", k, var.properties[k])])
}

resource "aws_msk_cluster" "default" {
  #bridgecrew:skip=BC_AWS_LOGGING_18:Skipping `Amazon MSK cluster logging is not enabled` check since it can be enabled with cloudwatch_logs_enabled = true 
  count                  = local.enabled ? 1 : 0
  cluster_name           = module.this.id
  kafka_version          = var.kafka_version
  number_of_broker_nodes = var.number_of_broker_nodes
  enhanced_monitoring    = var.enhanced_monitoring

  broker_node_group_info {
    instance_type   = var.broker_instance_type
    ebs_volume_size = var.broker_volume_size
    client_subnets  = var.subnet_ids
    security_groups = concat(var.broker_node_security_groups, aws_security_group.default.*.id)
  }

  configuration_info {
    arn      = aws_msk_configuration.config[0].arn
    revision = aws_msk_configuration.config[0].latest_revision
  }

  encryption_info {
    encryption_in_transit {
      client_broker = var.client_broker
      in_cluster    = var.encryption_in_cluster
    }
    encryption_at_rest_kms_key_arn = var.encryption_at_rest_kms_key_arn
  }

  dynamic "client_authentication" {
    for_each = var.client_tls_auth_enabled || var.client_sasl_scram_enabled || var.client_sasl_iam_enabled ? [1] : []
    content {
      dynamic "tls" {
        for_each = var.client_tls_auth_enabled ? [1] : []
        content {
          certificate_authority_arns = var.certificate_authority_arns
        }
      }
      dynamic "sasl" {
        for_each = var.client_sasl_scram_enabled ? [1] : []
        content {
          scram = var.client_sasl_scram_enabled
        }
      }
      dynamic "sasl" {
        for_each = var.client_sasl_iam_enabled ? [1] : []
        content {
          iam = var.client_sasl_iam_enabled
        }
      }
    }
  }

  open_monitoring {
    prometheus {
      jmx_exporter {
        enabled_in_broker = var.jmx_exporter_enabled
      }
      node_exporter {
        enabled_in_broker = var.node_exporter_enabled
      }
    }
  }

  logging_info {
    broker_logs {
      cloudwatch_logs {
        enabled   = var.cloudwatch_logs_enabled
        log_group = var.cloudwatch_logs_log_group
      }
      firehose {
        enabled         = var.firehose_logs_enabled
        delivery_stream = var.firehose_delivery_stream
      }
      s3 {
        enabled = var.s3_logs_enabled
        bucket  = var.s3_logs_bucket
        prefix  = var.s3_logs_prefix
      }
    }
  }

  lifecycle {
    ignore_changes = [
      # Ignore changes to ebs_volume_size in favor of autoscaling policy
      broker_node_group_info[0].ebs_volume_size,
    ]
  }

  tags = module.this.tags
}

resource "aws_msk_scram_secret_association" "default" {
  count = local.enabled && var.client_sasl_scram_enabled ? 1 : 0

  cluster_arn     = aws_msk_cluster.default[0].arn
  secret_arn_list = var.client_sasl_scram_secret_association_arns
}

module "hostname" {
  count = var.number_of_broker_nodes > 0 && var.zone_id != null ? var.number_of_broker_nodes : 0

  source  = "cloudposse/route53-cluster-hostname/aws"
  version = "0.12.2"

  enabled  = module.this.enabled && length(var.zone_id) > 0
  dns_name = "${module.this.name}-broker-${count.index + 1}"
  zone_id  = var.zone_id
  records  = [split(":", element(local.bootstrap_brokers_combined_list, count.index))[0]]

  context = module.this.context
}

resource "aws_appautoscaling_target" "default" {
  count = local.enabled ? 1 : 0

  max_capacity       = local.broker_volume_size_max
  min_capacity       = 1
  resource_id        = aws_msk_cluster.default[0].arn
  scalable_dimension = "kafka:broker-storage:VolumeSize"
  service_namespace  = "kafka"
}

resource "aws_appautoscaling_policy" "default" {
  count = local.enabled ? 1 : 0

  name               = "${aws_msk_cluster.default[0].cluster_name}-broker-scaling"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_msk_cluster.default[0].arn
  scalable_dimension = join("", aws_appautoscaling_target.default.*.scalable_dimension)
  service_namespace  = join("", aws_appautoscaling_target.default.*.service_namespace)

  target_tracking_scaling_policy_configuration {
    disable_scale_in = var.storage_autoscaling_disable_scale_in
    predefined_metric_specification {
      predefined_metric_type = "KafkaBrokerStorageUtilization"
    }

    target_value = var.storage_autoscaling_target_value
  }
}
