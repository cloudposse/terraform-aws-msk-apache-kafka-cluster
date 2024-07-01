provider "aws" {
  region = var.region
}

module "vpc" {
  source  = "cloudposse/vpc/aws"
  version = "2.1.0"

  ipv4_primary_cidr_block = "172.16.0.0/16"

  context = module.this.context
}

module "subnets" {
  source  = "cloudposse/dynamic-subnets/aws"
  version = "2.3.0"

  availability_zones   = var.availability_zones
  vpc_id               = module.vpc.vpc_id
  igw_id               = [module.vpc.igw_id]
  ipv4_cidr_block      = [module.vpc.vpc_cidr_block]
  nat_gateway_enabled  = false
  nat_instance_enabled = false

  context = module.this.context
}

module "kafka" {
  source = "../../"

  zone_id                  = var.zone_id
  vpc_id                   = module.vpc.vpc_id
  subnet_ids               = module.this.enabled ? module.subnets.private_subnet_ids : [""]
  kafka_version            = var.kafka_version
  broker_per_zone          = var.broker_per_zone
  broker_instance_type     = var.broker_instance_type
  public_access_enabled    = var.public_access_enabled
  broker_dns_records_count = var.broker_dns_records_count

  allowed_security_group_ids           = concat(var.allowed_security_group_ids, [module.vpc.vpc_default_security_group_id])
  allowed_cidr_blocks                  = var.allowed_cidr_blocks
  associated_security_group_ids        = var.associated_security_group_ids
  create_security_group                = var.create_security_group
  security_group_name                  = var.security_group_name
  security_group_description           = var.security_group_description
  security_group_create_before_destroy = var.security_group_create_before_destroy
  preserve_security_group_id           = var.preserve_security_group_id
  security_group_create_timeout        = var.security_group_create_timeout
  security_group_delete_timeout        = var.security_group_delete_timeout
  allow_all_egress                     = var.allow_all_egress
  additional_security_group_rules      = var.additional_security_group_rules
  inline_rules_enabled                 = var.inline_rules_enabled

  client_allow_unauthenticated                 = var.client_allow_unauthenticated
  client_sasl_scram_enabled                    = var.client_sasl_scram_enabled
  client_sasl_iam_enabled                      = var.client_sasl_iam_enabled
  client_tls_auth_enabled                      = var.client_tls_auth_enabled
  client_sasl_scram_secret_association_enabled = var.client_sasl_scram_secret_association_enabled
  client_sasl_scram_secret_association_arns    = var.client_sasl_scram_secret_association_arns

  certificate_authority_arns = var.certificate_authority_arns

  ## Use custom broker DNS name to avoid resource conflict for concurrent test runs
  ## `%%ID%%` is the expected placeholder for cluster node number in `custom_broker_dns_name`
  custom_broker_dns_name = format("msk-test-broker-%s-%s", var.attributes[0], "%%ID%%")

  context = module.this.context
}
