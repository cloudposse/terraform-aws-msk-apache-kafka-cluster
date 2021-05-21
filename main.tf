locals {
  bootstrap_brokers               = try(aws_msk_cluster.default[0].bootstrap_brokers, "")
  bootstrap_brokers_list          = local.bootstrap_brokers != "" ? sort(split(",", local.bootstrap_brokers)) : []
  bootstrap_brokers_tls           = try(aws_msk_cluster.default[0].bootstrap_brokers_tls, "")
  bootstrap_brokers_tls_list      = local.bootstrap_brokers_tls != "" ? sort(split(",", local.bootstrap_brokers_tls)) : []
  bootstrap_brokers_scram         = try(aws_msk_cluster.default[0].bootstrap_brokers_sasl_scram, "")
  bootstrap_brokers_scram_list    = local.bootstrap_brokers_scram != "" ? sort(split(",", local.bootstrap_brokers_scram)) : []
  bootstrap_brokers_combined_list = concat(local.bootstrap_brokers_list, local.bootstrap_brokers_tls_list, local.bootstrap_brokers_scram_list)
  security_group_enabled          = module.this.enabled && var.security_group_enabled
}

module "security_group" {
  source  = "cloudposse/security-group/aws"
  version = "0.3.1"

  use_name_prefix = var.security_group_use_name_prefix
  rules           = var.security_group_rules
  description     = var.security_group_description
  vpc_id          = var.vpc_id

  enabled = local.security_group_enabled
  context = module.this.context
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
    security_groups = compact(concat(module.security_group.*.id, var.security_groups))
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
    for_each = var.client_tls_auth_enabled || var.client_sasl_scram_enabled ? [1] : []
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
