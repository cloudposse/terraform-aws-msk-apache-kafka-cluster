variable "number_of_broker_nodes" {
  type    = number
  description = "The desired total number of broker nodes in the kafka cluster. It must be a multiple of the number of specified client subnets. It must be a multiple of the number of specified client subnets."
}

variable "kafka_version" {
  type    = string
  description = "The desired Kafka software version"
}

variable "broker_instance_type" {
  type    = string
  description = "The instance type to use for the Kafka brokers"
}

variable "broker_volume_size" {
  type    = number
  default = 1000
  description = "The size in GiB of the EBS volume for the data drive on each broker node"
}

variable "vpc_id" {
  type = string
  description = "VPC ID where subnets will be created (e.g. `vpc-aceb2723`)"
}

variable "subnet_ids" {
  type = list(string)
  description = "Subnet IDs"
}

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

variable "name" {
  type        = string
  default     = ""
  description = "Solution name, e.g. 'app' or 'cluster'"
}

variable "zone_id" {
  type = string
  description = "Route53 DNS Zone ID"
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

variable "client_broker" {
  type         = string
  default      = "TLS"
  description = "Encryption setting for data in transit between clients and brokers"
}

variable "encryption_in_cluster" {
  type = bool
  default = true
  description = "Whether data communication among broker nodes is encrypted"
}

variable "encryption_at_rest_kms_key_arn" {
  type = string
  default = ""
  description = "You may specify a KMS key short ID or ARN (it will always output an ARN) to use for encrypting your data at rest"
}

variable "enhanced_monitoring" {
  type        = string
  default     = "DEFAULT"
  description = "Specify the desired enhanced MSK CloudWatch monitoring level"
}

variable "certificate_authority_arns" {
  type = list(string)
  default = []
  description = "List of ACM Certificate Authority Amazon Resource Names (ARNs)"
}

variable "jmx_exporter_enabled" {
  type = bool
  default = false
  description = "Set `true` to enable the JMX Exporter"
}

variable "node_exporter_enabled" {
  type = bool
  default = false
  description = "Set `true` to enable the Node Exporter"
}

variable "cloudwatch_logs_enabled" {
  type = bool
  default = false
  description = "Indicates whether you want to enable or disable streaming broker logs to Cloudwatch Logs"
}

variable "cloudwatch_logs_log_group" {
  type = string
  default = ""
  description = "Name of the Cloudwatch Log Group to deliver logs to"
}

variable "firehose_logs_enabled" {
  type = bool
  default = false
  description = "Indicates whether you want to enable or disable streaming broker logs to Kinesis Data Firehose"
}

variable "firehose_delivery_stream" {
  type = string
  default = ""
  description = "Name of the Kinesis Data Firehose delivery stream to deliver logs to"
}

variable "s3_logs_enabled" {
  type = bool
  default = false
  description = " Indicates whether you want to enable or disable streaming broker logs to S3"
}

variable "s3_logs_bucket" {
  type = string
  default = ""
  description = "Name of the S3 bucket to deliver logs to"
}

variable "s3_logs_prefix" {
  type = string
  default = ""
  description = "Prefix to append to the S3 folder name logs are delivered to"
}

variable "properties" {
  type = map(string)
  default = {}
  description = "Contents of the server.properties file. Supported properties are documented in the [MSK Developer Guide](https://docs.aws.amazon.com/msk/latest/developerguide/msk-configuration-properties.html)"
}


