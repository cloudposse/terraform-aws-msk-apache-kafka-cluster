variable "region" {
  type        = string
  description = "AWS region"
  nullable    = false
}

variable "availability_zones" {
  type        = list(string)
  description = "List of availability zones for VPC creation"
  nullable    = false
}

variable "zone_id" {
  type        = string
  description = "ZoneID for DNS Hostnames of MSK Brokers"
}

variable "broker_dns_records_count" {
  type        = number
  description = <<-EOT
  This variable specifies how many DNS records to create for the broker endpoints in the DNS zone provided in the `zone_id` variable.
  This corresponds to the total number of broker endpoints created by the module.
  Calculate this number by multiplying the `broker_per_zone` variable by the subnet count.
  This variable is necessary to prevent the Terraform error:
  The "count" value depends on resource attributes that cannot be determined until apply, so Terraform cannot predict how many instances will be created.
  EOT
  default     = 0
  nullable    = false
}

variable "kafka_version" {
  type        = string
  description = <<-EOT
  The desired Kafka software version.
  Refer to https://docs.aws.amazon.com/msk/latest/developerguide/supported-kafka-versions.html for more details
  EOT
  nullable    = false
}

variable "broker_instance_type" {
  type        = string
  description = "Specify the instance type to use for the kafka brokers"
  nullable    = false
}

variable "broker_per_zone" {
  type        = number
  description = "Number of Kafka brokers per zone"
  nullable    = false
}

variable "public_access_enabled" {
  type        = bool
  default     = false
  description = "Enable public access to MSK cluster (given that all of the requirements are met)"
  nullable    = false
}

variable "vpc_connectivity" {
  description = <<-EOT
  Optional VPC connectivity settings. Set to null to omit the entire `vpc_connectivity` block.
  Provide booleans for SASL IAM and/or SCRAM.
  Example:
    vpc_connectivity = {
      sasl_iam_enabled   = true
      sasl_scram_enabled = true
    }
  EOT

  type = object({
    sasl_iam_enabled   = optional(bool)
    sasl_scram_enabled = optional(bool)
  })

  default  = null
  nullable = true

  validation {
    condition = var.vpc_connectivity == null
      || try(var.vpc_connectivity.sasl_iam_enabled, false)
      || try(var.vpc_connectivity.sasl_scram_enabled, false)
    error_message = "When vpc_connectivity is set, enable at least one of sasl_iam_enabled or sasl_scram_enabled."
  }
}
variable "client_allow_unauthenticated" {
  type        = bool
  default     = false
  description = "Enable unauthenticated access"
  nullable    = false
}

variable "client_sasl_iam_enabled" {
  type        = bool
  default     = false
  description = "Enable client authentication via IAM policies. Cannot be set to `true` at the same time as `client_tls_auth_enabled`"
  nullable    = false
}

variable "client_tls_auth_enabled" {
  type        = bool
  default     = false
  description = "Set `true` to enable the Client TLS Authentication"
  nullable    = false
}

variable "client_sasl_scram_enabled" {
  type        = bool
  default     = false
  description = "Enable SCRAM client authentication via AWS Secrets Manager. Cannot be set to `true` at the same time as `client_tls_auth_enabled`"
  nullable    = false
}

variable "certificate_authority_arns" {
  type        = list(string)
  default     = []
  description = "List of ACM Certificate Authority Amazon Resource Names (ARNs) to be used for TLS client authentication"
  nullable    = false
}

variable "client_sasl_scram_secret_association_enabled" {
  type        = bool
  default     = true
  description = "Enable the list of AWS Secrets Manager secret ARNs for SCRAM authentication"
  nullable    = false
}

variable "client_sasl_scram_secret_association_arns" {
  type        = list(string)
  default     = []
  description = "List of AWS Secrets Manager secret ARNs for SCRAM authentication"
  nullable    = false
}
