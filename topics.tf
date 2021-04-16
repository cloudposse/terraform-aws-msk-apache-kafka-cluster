module "kafka_topics" {
  count             = length(aws_msk_cluster.default.*.bootstrap_brokers) > 0 ? 1 : 0
  context           = module.this.context
  enabled           = true
  source            = "./modules/kafka_topcs"
  depends_on        = [aws_msk_cluster.default]
  bootstrap_servers = length(aws_msk_cluster.default.*.bootstrap_brokers) > 0 ? aws_msk_cluster.default.*.bootstrap_brokers : 0
  topic_config = [
    {
      name               = "test"
      partitions         = 0
      replication_factor = 0
      config             = {}
    }
  ]
}
