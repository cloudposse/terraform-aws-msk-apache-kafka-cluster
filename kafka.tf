module "kafka" {
  count             = length(aws_msk_cluster.default.*.bootstrap_brokers) > 0 ? 1 : 0
  context           = module.this.context
  enabled           = true
  source            = "./modules/kafka"
  depends_on        = [aws_msk_cluster.default]
  bootstrap_servers = length(aws_msk_cluster.default.*.bootstrap_brokers) > 0 ? aws_msk_cluster.default.*.bootstrap_brokers : 0
  topic_config = [
    {
      name               = "test"
      partitions         = 3
      replication_factor = 3
      config             = {}
    },
    {
      name               = "telematics_enrichment.Trakm8HiResAccelDTO.avro18.topic"
      partitions         = 3
      replication_factor = 3
      config             = {}
    },
    {
      name               = "telematics_enrichment.Trakm8HiResFilteredAccelDTO.avro18.topic"
      partitions         = 3
      replication_factor = 3
      config             = {}
    },
    {
      name               = "telematics_enrichment.Trakm8HiResData.json.topic"
      partitions         = 3
      replication_factor = 3
      config             = {}
    },
    {
      name               = "telematics_enrichment.TripPathDTO.avro18.topic"
      partitions         = 50
      replication_factor = 3
      config             = {}
    },
    {
      name               = "telematics_enrichment.Trakm8GpsDTO.avro18.topic"
      partitions         = 3
      replication_factor = 3
      config             = {}
    },
    {
      name               = "telematics_enrichment.TripSummaryDTO.avro18.topic"
      partitions         = 3
      replication_factor = 3
      config             = {}
    },
    {
      name               = "telematics_enrichment.HarshCornering.AccelEventDTO.avro18.topic"
      partitions         = 3
      replication_factor = 3
      config             = {}
    },
    {
      name               = "telematics_enrichment.HarshCornering.DrivingEventDTO.avro18.topic"
      partitions         = 3
      replication_factor = 3
      config             = {}
    },
    {
      name               = "telematics_enrichment.NoLeaseVin.VehicleStateDTO.avro18.topic"
      partitions         = 3
      replication_factor = 3
      config             = {}
    }
  ]
  acl_config = [
    {
      resource_name                = ""
      resource_type                = ""
      resource_pattern_type_filter = ""
      acl_principal                = ""
      acl_host                     = ""
      acl_operation                = ""
      acl_permission_type          = ""
    }
  ]
}
