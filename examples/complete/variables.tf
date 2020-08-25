variable "namespace" {
  type        = string
  description = "Namespace, which could be your organization name or abbreviation, e.g. 'eg' or 'cp'"
}

variable "stage" {
  type        = string
  description = "Stage, e.g. 'prod', 'staging', 'dev', or 'test'"
}

variable "name" {
  type        = string
  description = "Solution/application name, e.g. 'app' or 'cluster'"
}

variable "availability_zones" {
  type        = list(string)
  description = "List of availability zones"
}

variable "zone_id" {
  type = string
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
