module "vpc" {
  source     = "../modules/terraform-aws-vpc"
  namespace  = var.namespace
  stage      = var.stage
  name       = var.name
  cidr_block = "172.16.0.0/16"
}

module "subnets" {
  source               = "../modules/terraform-aws-dynamic-subnets"
  availability_zones   = var.availability_zones
  namespace            = var.namespace
  stage                = var.stage
  name                 = var.name
  vpc_id               = module.vpc.vpc_id
  igw_id               = module.vpc.igw_id
  cidr_block           = module.vpc.vpc_cidr_block
  nat_gateway_enabled  = true
  nat_instance_enabled = false
}

module "kafka" {
  source                 = "../modules/terraform-aws-msk-apache-kafka-cluster"
  namespace              = var.namespace
  stage                  = var.stage
  name                   = var.name
  zone_id                = var.zone_id
  security_groups        = [module.vpc.vpc_default_security_group_id]
  vpc_id                 = module.vpc.vpc_id
  subnet_ids             = module.subnets.private_subnet_ids
  kafka_version          = var.kafka_version
  number_of_broker_nodes = var.number_of_broker_nodes
  broker_instance_type   = var.broker_instance_type
}
