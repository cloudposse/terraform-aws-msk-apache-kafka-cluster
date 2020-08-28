provider "aws" {
  region = var.region
}

module "vpc" {
  source      = "git::https://github.com/cloudposse/terraform-aws-vpc.git?ref=tags/0.16.2"
  enabled     = var.enabled
  namespace   = var.namespace
  environment = var.environment
  stage       = var.stage
  name        = var.name
  delimiter   = var.delimiter
  attributes  = var.attributes
  tags        = var.tags
  cidr_block  = "172.16.0.0/16"
}

module "subnets" {
  source               = "git::https://github.com/cloudposse/terraform-aws-dynamic-subnets.git?ref=tags/0.27.0"
  enabled              = var.enabled
  namespace            = var.namespace
  environment          = var.environment
  stage                = var.stage
  name                 = var.name
  delimiter            = var.delimiter
  attributes           = var.attributes
  tags                 = var.tags
  availability_zones   = var.availability_zones
  vpc_id               = module.vpc.vpc_id
  igw_id               = module.vpc.igw_id
  cidr_block           = module.vpc.vpc_cidr_block
  nat_gateway_enabled  = true
  nat_instance_enabled = false
}

resource "random_id" "config_id" {
  count       = var.enabled ? 1 : 0
  byte_length = 2
}

module "kafka" {
  source                 = "../../"
  enabled                = var.enabled
  namespace              = var.namespace
  environment            = var.environment
  stage                  = var.stage
  name                   = "${var.name}${var.delimiter}${try(random_id.config_id[0].hex, "")}"
  delimiter              = var.delimiter
  attributes             = var.attributes
  tags                   = var.tags
  zone_id                = var.zone_id
  security_groups        = [module.vpc.vpc_default_security_group_id]
  vpc_id                 = module.vpc.vpc_id
  subnet_ids             = module.subnets.private_subnet_ids
  kafka_version          = var.kafka_version
  number_of_broker_nodes = var.number_of_broker_nodes
  broker_instance_type   = var.broker_instance_type
}
