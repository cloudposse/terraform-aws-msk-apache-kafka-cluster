variable "example" {
  description = "Example variable"
  default     = "hello world"
}


variable number_of_broker_nodes {
  type    = number
  default = 3
}

variable kafka_version {
  type    = string
  default = "2.4.1"
}

variable broker_instance_type {
  type    = string
  default = "kafka.m5.large"
}

variable broker_volume_size {
  type    = number
  default = 1000
}

variable vpc_id {
  type = string
}

variable subnet_ids {
  type = list(string)
}

variable "enabled" {
  type        = bool
  default     = true
  description = "Set to false to prevent the module from creating any resources"
}

variable "namespace" {
  type = string
}

variable "name" {
  type = string
}

variable "zone_id" {
  type = string
}

variable "stage" {
  type        = string
  default     = ""
  description = "Stage, e.g. 'prod', 'staging', 'dev', OR 'source', 'build', 'test', 'deploy', 'release'"
}

variable "environment" {
  type        = string
  default     = ""
  description = "Environment, e.g. 'prod', 'staging', 'dev', 'pre-prod', 'UAT'"
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

variable "label_order" {
  type        = list(string)
  default     = []
  description = "The naming order of the id output and Name tag"
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Additional tags (e.g. `map('BusinessUnit','XYZ')`"
}

variable "security_groups" {
  type        = list(string)
  default     = []
  description = "List of security group IDs to be allowed to connect to the cluster"
}

variable "allowed_cidr_blocks" {
  type        = list(string)
  default     = []
  description = "List of CIDR blocks to be allowed to connect to the cluster"
}

variable "kafka_topics" {
  type        = list(string)
  default     = []
  description = "List of Kafka topics to be created"
}
