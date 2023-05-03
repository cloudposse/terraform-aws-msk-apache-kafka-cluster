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
