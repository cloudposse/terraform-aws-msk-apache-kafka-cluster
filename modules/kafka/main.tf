resource "kafka_topic" "default" {
  for_each           = module.this.enabled == true && length(var.topic_config) > 0 ? { for t in var.topic_config : t.name => t } : {}
  name               = each.value.name
  partitions         = each.value.partitions
  replication_factor = each.value.replication_factor
  config             = each.value.config
}


resource "kafka_acl" "default" {
  for_each            = module.this.enabled == true && length(var.acl_config) > 0 ? { for t in var.acl_config : t.name => t } : {}
  resource_name       = each.value.resource_name
  resource_type       = each.value.resource_type
  acl_principal       = each.value.acl_principal
  acl_host            = each.value.acl_host
  acl_operation       = each.value.acl_operation
  acl_permission_type = each.value.acl_permission_type
}
