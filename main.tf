locals {
  bootstrap_brokers = try(aws_msk_cluster.default[0].bootstrap_brokers, "")
  bootstrap_brokers_list = local.bootstrap_brokers != "" ? sort(split(",", local.bootstrap_brokers)) : []
  bootstrap_brokers_tls = try(aws_msk_cluster.default[0]. bootstrap_brokers_tls, "")
  bootstrap_brokers_tls_list = local.bootstrap_brokers_tls != "" ? sort(split(",", local.bootstrap_brokers_tls)) : []
}


module "label" {
  source      = "git::https://github.com/cloudposse/terraform-null-label.git?ref=tags/0.17.0"
  enabled     = var.enabled
  namespace   = var.namespace
  environment = var.environment
  stage       = var.stage
  name        = var.name
  delimiter   = var.delimiter
  attributes  = var.attributes
  tags        = var.tags
  label_order = var.label_order
}

resource "aws_security_group" "default" {
  count       = var.enabled ? 1 : 0
  vpc_id      = var.vpc_id
  name        = module.label.id
  description = "Allow inbound traffic from Security Groups and CIDRs. Allow all outbound traffic"
  tags        = module.label.tags
}

resource "aws_security_group_rule" "ingress_security_groups" {
  count                    = var.enabled ? length(var.security_groups) : 0
  description              = "Allow inbound traffic from Security Groups"
  type                     = "ingress"
  from_port                = 0
  to_port                  = 65535
  protocol                 = "tcp"
  source_security_group_id = var.security_groups[count.index]
  security_group_id        = join("", aws_security_group.default.*.id)
}

resource "aws_security_group_rule" "ingress_cidr_blocks" {
  count             = var.enabled && length(var.allowed_cidr_blocks) > 0 ? 1 : 0
  description       = "Allow inbound traffic from CIDR blocks"
  type              = "ingress"
  from_port         = 0
  to_port           = 65535
  protocol          = "tcp"
  cidr_blocks       = var.allowed_cidr_blocks
  security_group_id = join("", aws_security_group.default.*.id)
}

resource "aws_security_group_rule" "egress" {
  count             = var.enabled ? 1 : 0
  description       = "Allow all egress traffic"
  type              = "egress"
  from_port         = 0
  to_port           = 65535
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = join("", aws_security_group.default.*.id)
}

resource "aws_msk_configuration" "config" {
  count          = var.enabled ? 1 : 0
  kafka_versions = [var.kafka_version]
  name           = module.label.id
  description    = "Manages an Amazon Managed Streaming for Kafka configuration"

  server_properties = join("\n", [for k in keys(var.properties) : format("%s = %s", k, var.properties[k])])
}

resource "aws_msk_cluster" "default" {
  count                  = var.enabled ? 1 : 0
  cluster_name           = module.label.id
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
    for_each = var.client_tls_auth_enabled ? [1] : []

    content {
      tls {
        certificate_authority_arns = var.certificate_authority_arns
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

  tags = module.label.tags
}

module "hostname" {
  count   = var.number_of_broker_nodes > 0 ? var.number_of_broker_nodes : 0
  source  = "git::https://github.com/cloudposse/terraform-aws-route53-cluster-hostname.git?ref=tags/0.5.0"
  enabled = var.enabled && length(var.zone_id) > 0
  name    = "${module.label.id}-broker-${count.index + 1}"
  zone_id = var.zone_id
  records = length(local.bootstrap_brokers > 0) ? bootstrap_brokers_list : bootstrap_brokers_tls_list
}
