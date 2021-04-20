variable "topic_config" {
  type = list(object({
    name               = string
    partitions         = number
    replication_factor = number
    config             = map(string)
  }))
  default = [
    {
      name               = null
      partitions         = null
      replication_factor = null
      config             = {}
    }
  ]
  description = <<-EOT
        Config for managing Kafka topics. Increases partition count without destroying the topic.
            name - (Required) The name of the topic..
            partitions - (Required) The number of partitions the topic should have.
            replication_factor - (Required) The number of replicas the topic should have.
            config - (Optional) A map of string k/v attributes.
    EOT
}

variable "acl_config" {
  type = list(object({
    resource_name                = string
    resource_type                = string
    resource_pattern_type_filter = string
    acl_principal                = string
    acl_host                     = string
    acl_operation                = string
    acl_permission_type          = string
  }))
  default = [
    {
      resource_name                = null
      resource_type                = null
      resource_pattern_type_filter = null
      acl_principal                = null
      acl_host                     = null
      acl_operation                = null
      acl_permission_type          = null
    }
  ]
  description = <<-EOT
        Config for managing Kafka ACLs.
        resource_name - (Required) The name of the resource.
        resource_type - (Required) The type of resource. Valid values are Unknown, Any, Topic, Group, Cluster, TransactionalID.
        resource_pattern_type_filter - (Required) The pattern filter. Valid values are Prefixed, Any, Match, Literal.
        acl_principal - (Required) Principal that is being allowed or denied.
        acl_host - (Required) Host from which principal listed in acl_principal will have access.
        acl_operation - (Required) Operation that is being allowed or denied. Valid values are Unknown, Any, All, Read, Write, Create, Delete, Alter, Describe, ClusterAction, DescribeConfigs, AlterConfigs, IdempotentWrite.
        acl_permission_type - (Required) Type of permission. Valid values are Unknown, Any, Allow, Deny.
    EOT
}

variable "bootstrap_servers" {
  type        = list(string)
  description = "(Required) A list of host:port addresses that will be used to discover the full set of alive brokers."
}
