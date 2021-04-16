resource "kafka_topic" "default" {
  for_each           = module.this.enabled == true && length(var.topic_config) > 0 ? { for t in var.topic_config : t.name => t } : {}
  name               = each.value.name
  partitions         = each.value.partitions
  replication_factor = each.value.replication_factor
  config             = each.value.config
}
