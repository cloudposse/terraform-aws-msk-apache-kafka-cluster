module "label" {
  source      = "git::https://github.com/cloudposse/terraform-null-label.git?ref=tags/0.17.0"
  enabled     = var.enabled
  namespace   = var.namespace
  name        = var.name
  stage       = var.stage
  environment = var.environment
  delimiter   = var.delimiter
  attributes  = var.attributes
  label_order = var.label_order
  tags        = var.tags
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

resource "random_id" "config_id" {
  count             = var.enabled ? 1 : 0
  byte_length = 2
}

resource aws_msk_configuration config {
  count             = var.enabled ? 1 : 0
  kafka_versions = ["2.3.1", "2.4.1"]
  name           = "${module.label.id}-${random_id.config_id[0].hex}"

  server_properties = <<PROPERTIES
    auto.create.topics.enable = true
    log.retention.hours = -1
    default.replication.factor = 3
    min.insync.replicas = 2
    num.io.threads = 8
    num.network.threads = 5
    num.partitions = 10
  PROPERTIES
}

resource aws_msk_cluster default {
  count                  = var.enabled ? 1 : 0
  cluster_name           = module.label.id
  kafka_version          = var.kafka_version
  number_of_broker_nodes = var.number_of_broker_nodes

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
      client_broker = "PLAINTEXT"
    }
  }

  tags = module.label.tags
}

module "hostname" {
  count   = var.enabled && var.number_of_broker_nodes > 0 ? var.number_of_broker_nodes : 0

  source = "../terraform-aws-route53-cluster-hostname"

  enabled = var.enabled
  name    = "${module.label.id}-broker-${count.index+1}"
  zone_id = var.zone_id
  records = [split(":", sort(split(",", aws_msk_cluster.default[0].bootstrap_brokers))[count.index])[0]]
}
