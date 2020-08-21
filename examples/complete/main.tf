locals {
    enabled = true
    namespace = "tfx" 
    stage = "dev"
    name = "lab"
    zone_id = "Z3BDU8BGTMK3OR"
    cidr_block = "172.16.0.0/16"
    availability_zones = ["us-east-2a","us-east-2b","us-east-2c"]
    nat_gateway_enabled = true
    nat_instance_enabled = false
}

module "vpc" {
  source     = "../modules/terraform-aws-vpc"
  namespace  = local.namespace
  stage      = local.stage
  name       = local.name
  cidr_block = local.cidr_block
}

module "subnets" {
  source               = "../modules/terraform-aws-dynamic-subnets"
  availability_zones   = local.availability_zones
  namespace            = local.namespace
  stage                = local.stage
  name                 = local.name
  vpc_id               = module.vpc.vpc_id
  igw_id               = module.vpc.igw_id
  cidr_block           = module.vpc.vpc_cidr_block
  nat_gateway_enabled  = local.nat_gateway_enabled
  nat_instance_enabled = local.nat_instance_enabled
}

module "kafka" {
  source                 = "../modules/terraform-aws-msk-apache-kafka-cluster"
  enabled                = local.enabled
  namespace              = local.namespace
  stage                  = local.stage
  name                   = local.name
  zone_id                = local.zone_id
  security_groups        = [module.vpc.vpc_default_security_group_id]
  vpc_id                 = module.vpc.vpc_id
  subnet_ids             = module.subnets.private_subnet_ids
}
