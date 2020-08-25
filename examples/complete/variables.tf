variable "enabled" {
  type        = bool
  default     = true
  description = "Set to false to prevent the module from creating any resources"
}

variable "namespace" {
  type        = string
  default     = ""
  description = "Namespace, which could be your organization name or abbreviation, e.g. 'eg' or 'cp'"
}

variable "environment" {
  type        = string
  default     = ""
  description = "Environment, e.g. 'ue2', 'us-east-2', OR 'prod', 'staging', 'dev', 'pre-prod', 'UAT'"
}

variable "stage" {
  type        = string
  default     = ""
  description = "Stage, e.g. 'prod', 'staging', 'dev', OR 'source', 'build', 'test', 'deploy', 'release'"
}

variable "name" {
  type        = string
  default     = ""
  description = "Solution name, e.g. 'app' or 'cluster'"
}

variable "delimiter" {
  type        = string
  default     = "-"
  description = "Delimiter to be used between `namespace`, `environment`, `stage`, `name` and `attributes`"
}

variable "attributes" {
  type        = list(string)
  default     = []
  description = "Additional attributes (e.g. `1`)"
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Additional tags (e.g. `map('BusinessUnit','XYZ')`"
}

variable "label_order" {
  type        = list(string)
  default     = []
  description = "The naming order of the id output and Name tag"
}

variable "availability_zones" {
  type        = list(string)
  description = "List of availability zones for VPC creation"
}

variable "zone_id" {
  type        = string
  description = "ZoneID for DNS Hostnames of MSK Brokers"
}

variable "kafka_version" {
  type        = string
  description = "Specify the desired Kafka software version"
}

variable "broker_instance_type" {
  type        = string
  description = "Specify the instance type to use for the kafka brokers"
}

variable "number_of_broker_nodes" {
  type        = number
  description = "The desired total number of broker nodes in the kafka cluster. It must be a multiple of the number of specified client subnets. It must be a multiple of the number of specified client subnets."
}
