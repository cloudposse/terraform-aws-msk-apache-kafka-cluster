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
