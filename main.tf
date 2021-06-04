locals {
  bootstrap_brokers               = try(aws_msk_cluster.default[0].bootstrap_brokers, "")
  bootstrap_brokers_list          = local.bootstrap_brokers != "" ? sort(split(",", local.bootstrap_brokers)) : []
  bootstrap_brokers_tls           = try(aws_msk_cluster.default[0].bootstrap_brokers_tls, "")
  bootstrap_brokers_tls_list      = local.bootstrap_brokers_tls != "" ? sort(split(",", local.bootstrap_brokers_tls)) : []
  bootstrap_brokers_scram         = try(aws_msk_cluster.default[0].bootstrap_brokers_sasl_scram, "")
  bootstrap_brokers_scram_list    = local.bootstrap_brokers_scram != "" ? sort(split(",", local.bootstrap_brokers_scram)) : []
  bootstrap_brokers_combined_list = concat(local.bootstrap_brokers_list, local.bootstrap_brokers_tls_list, local.bootstrap_brokers_scram_list)
}

resource "aws_security_group" "default" {
  count       = module.this.enabled ? 1 : 0
  vpc_id      = var.vpc_id
  name        = module.this.id
  description = "Allow inbound traffic from Security Groups and CIDRs. Allow all outbound traffic"
  tags        = module.this.tags
}

resource "aws_security_group_rule" "ingress_security_groups" {
  count                    = module.this.enabled ? length(var.security_groups) : 0
  description              = "Allow inbound traffic from Security Groups"
  type                     = "ingress"
  from_port                = 0
  to_port                  = 65535
  protocol                 = "tcp"
  source_security_group_id = var.security_groups[count.index]
  security_group_id        = join("", aws_security_group.default.*.id)
}

resource "aws_security_group_rule" "ingress_cidr_blocks" {
  count             = module.this.enabled && length(var.allowed_cidr_blocks) > 0 ? 1 : 0
  description       = "Allow inbound traffic from CIDR blocks"
  type              = "ingress"
  from_port         = 0
  to_port           = 65535
  protocol          = "tcp"
  cidr_blocks       = var.allowed_cidr_blocks
  security_group_id = join("", aws_security_group.default.*.id)
}

resource "aws_security_group_rule" "egress" {
  count             = module.this.enabled ? 1 : 0
  description       = "Allow all egress traffic"
  type              = "egress"
  from_port         = 0
  to_port           = 65535
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = join("", aws_security_group.default.*.id)
}

resource "aws_msk_configuration" "config" {
  count          = module.this.enabled ? 1 : 0
  kafka_versions = [var.kafka_version]
  name           = module.this.id
  description    = "Manages an Amazon Managed Streaming for Kafka configuration"

  server_properties = join("\n", [for k in keys(var.properties) : format("%s = %s", k, var.properties[k])])
}

resource "aws_msk_cluster" "default" {
  count                  = module.this.enabled ? 1 : 0
  cluster_name           = module.this.id
  kafka_version          = var.kafka_version
  number_of_broker_nodes = var.number_of_broker_nodes
  enhanced_monitoring    = var.enhanced_monitoring

  broker_node_group_info {
    instance_type   = var.broker_instance_type
    ebs_volume_size = var.broker_volume_size
    client_subnets  = var.subnet_ids
    security_groups = aws_security_group.default.*.id
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

  tags = module.this.tags
}

resource "aws_msk_scram_secret_association" "default" {
  count = var.client_sasl_scram_enabled ? 1 : 0

  cluster_arn     = aws_msk_cluster.default[0].arn
  secret_arn_list = var.client_sasl_scram_secret_association_arns
}

module "hostname" {
  count   = (var.number_of_broker_nodes > 0) && (var.zone_id != null) ? var.number_of_broker_nodes : 0
  source  = "cloudposse/route53-cluster-hostname/aws"
  version = "0.12.0"
  enabled = module.this.enabled && length(var.zone_id) > 0
  name    = "${module.this.name}-broker-${count.index + 1}"
  zone_id = var.zone_id
  records = [split(":", local.bootstrap_brokers_combined_list[count.index])[0]]

  context = module.this.context
}
