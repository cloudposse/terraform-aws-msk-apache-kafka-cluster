provider "aws" {
  region = var.region
}

module "vpc" {
  source  = "cloudposse/vpc/aws"
  version = "2.0.0"

  ipv4_primary_cidr_block = "172.16.0.0/16"

  context = module.this.context
}

module "subnets" {
  source  = "cloudposse/dynamic-subnets/aws"
  version = "2.0.4"

  availability_zones   = var.availability_zones
  vpc_id               = module.vpc.vpc_id
  igw_id               = [module.vpc.igw_id]
  ipv4_cidr_block      = [module.vpc.vpc_cidr_block]
  nat_gateway_enabled  = false
  nat_instance_enabled = false

  context = module.this.context
}

resource "random_id" "config_id" {
  count = module.this.enabled ? 1 : 0

  byte_length = 2
}

module "kafka" {
  source = "../../"

  zone_id               = var.zone_id
  security_groups       = [module.vpc.vpc_default_security_group_id]
  vpc_id                = module.vpc.vpc_id
  subnet_ids            = module.this.enabled ? module.subnets.private_subnet_ids : [""]
  kafka_version         = var.kafka_version
  broker_per_zone       = var.broker_per_zone
  broker_instance_type  = var.broker_instance_type
  public_access_enabled = var.public_access_enabled

  name = "${module.this.name}${module.this.delimiter}${try(random_id.config_id[0].hex, "")}"

  context = module.this.context
}
