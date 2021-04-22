module "kafka" {
  count             = length(aws_msk_cluster.default.*.bootstrap_brokers) > 0 ? 1 : 0
  context           = module.this.context
  enabled           = true
  source            = "./modules/kafka"
  depends_on        = [aws_msk_cluster.default]
  bootstrap_servers = length(aws_msk_cluster.default.*.bootstrap_brokers) > 0 ? aws_msk_cluster.default.*.bootstrap_brokers : 0
  topic_config = [
    {
      name               = "telematics_enrichment.DriverScoreDTO.avro18.topic"
      partitions         = 3
      replication_factor = 3
      config             = {}
    },
    {
      name               = "telematics_enrichment.TripPath.VehicleStateDTO.avro18.DLQ_topic"
      partitions         = 3
      replication_factor = 3
      config             = {}
    },
    {
      name               = "telematics_enrichment.Calibrated.Trakm8HiResAccelDTO.avro18.topic"
      partitions         = 3
      replication_factor = 3
      config             = {}
    },
    {
      name               = "telematics_enrichment.VueHiResData.json.topic"
      partitions         = 3
      replication_factor = 3
      config             = {}
    },
    {
      name               = "telematics_enrichment.Trakm8Speeding.json.DLQ_topic"
      partitions         = 3
      replication_factor = 3
      config             = {}
    },
    {
      name               = "telematics_enrichment.VinToImeiMappingDynDbStreamEventDTO.avro18.topic"
      partitions         = 3
      replication_factor = 3
      config             = {}
    },
    {
      name               = "telematics_enrichment.HarshBraking.AccelEventDTO.avro18.topic"
      partitions         = 3
      replication_factor = 3
      config             = {}
    },
    {
      name               = "telematics_enrichment.CalampAccelDTO.avro18.topic"
      partitions         = 3
      replication_factor = 3
      config             = {}
    },
    {
      name               = "telematics_enrichment.Trakm8Gps.json.topic"
      partitions         = 3
      replication_factor = 3
      config             = {}
    },
    {
      name               = "telematics_enrichment.Trakm8JnySumDTO.avro18.topic"
      partitions         = 3
      replication_factor = 3
      config             = {}
    },
    {
      name               = "telematics_enrichment.SpeedLimitDTO.avro18.topic"
      partitions         = 3
      replication_factor = 3
      config             = {}
    },
    {
      name               = "telematics_enrichment.Trakm8HarshAcceleration.json.topic"
      partitions         = 3
      replication_factor = 3
      config             = {}
    },
    {
      name               = "telematics_enrichment.Flespi.Trakm8Gps.json.topic"
      partitions         = 3
      replication_factor = 3
      config             = {}
    },
    {
      name               = "telematics_enrichment.municError_avro18.topic"
      partitions         = 3
      replication_factor = 3
      config             = {}
    },
    {
      name               = "telematics_enrichment.RacStandardExtended.json.topic"
      partitions         = 3
      replication_factor = 3
      config             = {}
    },
    {
      name               = "telematics_enrichment.RacExtendedAdditional.json.topic"
      partitions         = 3
      replication_factor = 3
      config             = {}
    },
    {
      name               = "telematics_enrichment.RacExtendedAdditional.json.DLQ_topic"
      partitions         = 3
      replication_factor = 3
      config             = {}
    },
    {
      name               = "telematics_enrichment.Flespi.Trakm8HiResGps.json.topic"
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
      name               = "telematics_enrichment.HarshAcceleration.AccelVectorDTO.avro18.DLQ_topic"
      partitions         = 3
      replication_factor = 3
      config             = {}
    },
    {
      name               = "telematics_enrichment.VueHiResFilteredAccelDTO.avro18.topic"
      partitions         = 3
      replication_factor = 3
      config             = {}
    },
    {
      name               = "telematics_enrichment.CalampAccelDTO.avro18.DLQ_topic"
      partitions         = 3
      replication_factor = 3
      config             = {}
    },
    {
      name               = "telematics_enrichment.SpeedingEventDTO.avro18.DLQ_topic"
      partitions         = 3
      replication_factor = 3
      config             = {}
    },
    {
      name               = "telematics_enrichment.TripEventDTO.avro18.topic"
      partitions         = 3
      replication_factor = 3
      config             = {}
    },
    {
      name               = "telematics_enrichment.Trakm8HiResGpsDTO.json.topic"
      partitions         = 3
      replication_factor = 3
      config             = {}
    },
    {
      name               = "service_trip_enrichment.TripInfoScoreDTO.avro18.topic"
      partitions         = 3
      replication_factor = 3
      config             = {}
    },
    {
      name               = "telematics_enrichment.LeaseDynDbStreamEventDTO.avro18.topic"
      partitions         = 3
      replication_factor = 3
      config             = {}
    },
    {
      name               = "telematics_enrichment.CalampAccel.json.topic"
      partitions         = 3
      replication_factor = 3
      config             = {}
    },
    {
      name               = "telematics_enrichment.Flespi.Trakm8HiResAccelDTO.avro18.topic"
      partitions         = 3
      replication_factor = 3
      config             = {}
    },
    {
      name               = "telematics_enrichment.TripPathDTO.avro18.SYSTEM_TESTS_topic"
      partitions         = 3
      replication_factor = 3
      config             = {}
    },
    {
      name               = "telematics_enrichment.Trakm8CalibrationData.json.DLQ_topic"
      partitions         = 3
      replication_factor = 3
      config             = {}
    },
    {
      name               = "telematics_enrichment.VueHiResAccel.json.DLQ_topic"
      partitions         = 3
      replication_factor = 3
      config             = {}
    },
    {
      name               = "telematics_enrichment.VehicleStateIgnitionChange.VehicleStateLeaseDTO.avro18.DLQ_topic"
      partitions         = 3
      replication_factor = 3
      config             = {}
    },
    {
      name               = "telematics_enrichment.Fatigue.json.topic"
      partitions         = 3
      replication_factor = 3
      config             = {}
    },
    {
      name               = "telematics_enrichment.Trakm8HarshBraking.json.DLQ_topic"
      partitions         = 3
      replication_factor = 3
      config             = {}
    },
    {
      name               = "telematics_enrichment.HarshBraking.Trakm8DataDTO.avro18.topic"
      partitions         = 3
      replication_factor = 3
      config             = {}
    },
    {
      name               = "telematics_enrichment.HarshCornering.AccelVectorDTO.avro18.DLQ_topic"
      partitions         = 3
      replication_factor = 3
      config             = {}
    },
    {
      name               = "telematics_enrichment.FatigueDTO.avro18.topic"
      partitions         = 3
      replication_factor = 3
      config             = {}
    },
    {
      name               = "telematics_enrichment.Trakm8CalibrationData.json.topic"
      partitions         = 3
      replication_factor = 3
      config             = {}
    },
    {
      name               = "telematics_enrichment.Trakm8CalibrationDataDTO.avro18.topic"
      partitions         = 3
      replication_factor = 3
      config             = {}
    },
    {
      name               = "telematics_enrichment.VueHiResGpsDTO.avro18.topic"
      partitions         = 3
      replication_factor = 3
      config             = {}
    },
    {
      name               = "telematics_enrichment.VehicleGpsDTO.avro18.topic"
      partitions         = 3
      replication_factor = 3
      config             = {}
    },
    {
      name               = "telematics_enrichment.RacStandardExtendedDTO.avro18.DLQ_topic"
      partitions         = 3
      replication_factor = 3
      config             = {}
    },
    {
      name               = "telematics_enrichment.Trakm8HiResDataDTO.avro18.topic"
      partitions         = 3
      replication_factor = 3
      config             = {}
    },
    {
      name               = "telematics_enrichment.Flespi.Trakm8GpsDTO.avro18.topic"
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
      name               = "telematics_enrichment.VinToImeiMapping_dyndbevent.json.DLQ_topic"
      partitions         = 3
      replication_factor = 3
      config             = {}
    },
    {
      name               = "epsagon-poc-avro"
      partitions         = 3
      replication_factor = 3
      config             = {}
    },
    {
      name               = "telematics_enrichment.Trakm8HarshAcceleration.json.DLQ_topic"
      partitions         = 3
      replication_factor = 3
      config             = {}
    },
    {
      name               = "telematics_enrichment.Trakm8HiResGpsDTO9.json.DLQ_topic"
      partitions         = 3
      replication_factor = 3
      config             = {}
    },
    {
      name               = "service_fatigue.FatigueDTO.json.topic"
      partitions         = 3
      replication_factor = 3
      config             = {}
    },
    {
      name               = "telematics_enrichment.Flespi.VehicleStateDTO.avro18.topic"
      partitions         = 3
      replication_factor = 3
      config             = {}
    },
    {
      name               = "telematics_enrichment.RacStandardExtendedDTO.avro18.topic"
      partitions         = 3
      replication_factor = 3
      config             = {}
    },
    {
      name               = "epsagon-poc-output"
      partitions         = 3
      replication_factor = 3
      config             = {}
    },
    {
      name               = "telematics_enrichment.SpeedingEventDTO.avro18.topic"
      partitions         = 3
      replication_factor = 3
      config             = {}
    },
    {
      name               = "telematics_enrichment.VehicleStateDTO.avro18.DLQ_topic"
      partitions         = 3
      replication_factor = 3
      config             = {}
    },
    {
      name               = "telematics_enrichment.CalampObdDTO.avro18.DLQ_topic"
      partitions         = 3
      replication_factor = 3
      config             = {}
    },
    {
      name               = "telematics_enrichment.RacStandardExtended.json.DLQ_topic"
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
      name               = "telematics_enrichment.Trakm8HiResAccelDTO.json.DLQ_topic"
      partitions         = 3
      replication_factor = 3
      config             = {}
    },
    {
      name               = "_schemas"
      partitions         = 3
      replication_factor = 3
      config             = {}
    },
    {
      name               = "telematics_enrichment.Flespi.Trakm8HiResData.json.topic"
      partitions         = 3
      replication_factor = 3
      config             = {}
    },
    {
      name               = "telematics_enrichment.VinToImeiMapping_dyndbevent.json.topic"
      partitions         = 3
      replication_factor = 3
      config             = {}
    },
    {
      name               = "telematics_enrichment.HarshBraking.AccelEventDTO.avro18.DLQ_topic"
      partitions         = 3
      replication_factor = 3
      config             = {}
    },
    {
      name               = "telematics_enrichment.Trakm8JnySum.json.DLQ_topic"
      partitions         = 3
      replication_factor = 3
      config             = {}
    },
    {
      name               = "telematics_enrichment.VueHiResGpsDTO.avro18.DLQ_topic"
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
      name               = "telematics_enrichment.HarshBraking.AccelVectorDTO.avro18.DLQ_topic"
      partitions         = 3
      replication_factor = 3
      config             = {}
    },
    {
      name               = "telematics_enrichment.RacExtendedAdditionalDTO.avro18.topic"
      partitions         = 3
      replication_factor = 3
      config             = {}
    },
    {
      name               = "telematics_enrichment.VehicleStateDTO.avro18.topic"
      partitions         = 3
      replication_factor = 3
      config             = {}
    },
    {
      name               = "telematics_enrichment.VueHiResDataTEST.json.topic"
      partitions         = 3
      replication_factor = 3
      config             = {}
    },
    {
      name               = "webhook-dev-trash"
      partitions         = 3
      replication_factor = 3
      config             = {}
    },
    {
      name               = "service_actions.TripSummaryDynDbEvent.json.topic"
      partitions         = 3
      replication_factor = 3
      config             = {}
    },
    {
      name               = "telematics_enrichment.HarshBraking.DrivingEventDTO.avro18.topic"
      partitions         = 3
      replication_factor = 3
      config             = {}
    },
    {
      name               = "telematics_enrichment.Lease_dyndbevent.json.topic"
      partitions         = 3
      replication_factor = 3
      config             = {}
    },
    {
      name               = "telematics_enrichment.CalampGpsDTO.avro18.DLQ_topic"
      partitions         = 3
      replication_factor = 3
      config             = {}
    },
    {
      name               = "telematics_enrichment.Lease_dyndbevent.json.DLQ_topic"
      partitions         = 3
      replication_factor = 3
      config             = {}
    },
    {
      name               = "telematics_enrichment.Flespi.VehicleState.json.topic"
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
      name               = "telematics_enrichment.VehicleStateLeaseDTO.avro18.DLQ_topic"
      partitions         = 3
      replication_factor = 3
      config             = {}
    },
    {
      name               = "telematics_enrichment.VinToImeiMappingDynDbStreamEventDTO.avro18.DLQ_topic"
      partitions         = 3
      replication_factor = 3
      config             = {}
    },
    {
      name               = "telematics_enrichment.Trakm8JnySum.json.topic"
      partitions         = 3
      replication_factor = 3
      config             = {}
    },
    {
      name               = "telematics_enrichment.CalampFilteredAccelDTO.avro18.topic"
      partitions         = 3
      replication_factor = 3
      config             = {}
    },
    {
      name               = "telematics_enrichment.Trakm8HarshCornering.json.topic"
      partitions         = 3
      replication_factor = 3
      config             = {}
    },
    {
      name               = "telematics_enrichment.HarshAcceleration.Trakm8DataDTO.avro18.topic"
      partitions         = 3
      replication_factor = 3
      config             = {}
    },
    {
      name               = "telematics_enrichment.HarshCornering.AccelEventDTO.avro18.DLQ_topic"
      partitions         = 3
      replication_factor = 3
      config             = {}
    },
    {
      name               = "telematics_enrichment.HarshAcceleration.DrivingEventDTO.avro18.topic"
      partitions         = 3
      replication_factor = 3
      config             = {}
    },
    {
      name               = "telematics_enrichment.AccelVectorDTO.avro18.topic"
      partitions         = 3
      replication_factor = 3
      config             = {}
    },
    {
      name               = "telematics_enrichment.NoLeaseVin.VehicleStateDTO.avro18.topic"
      partitions         = 3
      replication_factor = 3
      config             = {}
    },
    {
      name               = "telematics_enrichment.TripSummaryDTO.avro18.SYSTEM_TESTS_topic"
      partitions         = 3
      replication_factor = 3
      config             = {}
    },
    {
      name               = "telematics_enrichment.RacExtendedAdditionalDTO.avro18.DLQ_topic"
      partitions         = 3
      replication_factor = 3
      config             = {}
    },
    {
      name               = "telematics_enrichment.VehicleStateSummary.VehicleStateLeaseDTO.avro18.topic"
      partitions         = 3
      replication_factor = 3
      config             = {}
    },
    {
      name               = "telematics_enrichment.Trakm8HiResAccelDTO.json.topic"
      partitions         = 3
      replication_factor = 3
      config             = {}
    },
    {
      name               = "telematics_enrichment.VueHiResGps.json.DLQ_topic"
      partitions         = 3
      replication_factor = 3
      config             = {}
    },
    {
      name               = "telematics_enrichment.Trakm8HiResAccel.json.DLQ_topic"
      partitions         = 3
      replication_factor = 3
      config             = {}
    },
    {
      name               = "telematics_enrichment.Trakm8Speeding.json.topic"
      partitions         = 3
      replication_factor = 3
      config             = {}
    },
    {
      name               = "telematics_enrichment.HarshAcceleration.AccelEventDTO.avro18.DLQ_topic"
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
      name               = "telematics_enrichment.Trakm8GpsDTO.avro18.DLQ_topic"
      partitions         = 3
      replication_factor = 3
      config             = {}
    },
    {
      name               = "telematics_enrichment.Speeding.DrivingEventDTO.avro18.topic"
      partitions         = 3
      replication_factor = 3
      config             = {}
    },
    {
      name               = "telematics_enrichment.HarshAcceleration.AccelEventDTO.avro18.topic"
      partitions         = 3
      replication_factor = 3
      config             = {}
    },
    {
      name               = "telematics_enrichment.CalampGps.json.topic"
      partitions         = 3
      replication_factor = 3
      config             = {}
    },
    {
      name               = "telematics_enrichment.HarshCornering.Trakm8DataDTO.avro18.topic"
      partitions         = 3
      replication_factor = 3
      config             = {}
    },
    {
      name               = "telematics_enrichment.CalampObdDTO.avro18.topic"
      partitions         = 3
      replication_factor = 3
      config             = {}
    },
    {
      name               = "telematics_enrichment.Trakm8HiResGpsDTO.avro18.topic"
      partitions         = 3
      replication_factor = 3
      config             = {}
    },
    {
      name               = "telematics_enrichment.Trakm8HiResGps.json.DLQ_topic"
      partitions         = 3
      replication_factor = 3
      config             = {}
    },
    {
      name               = "telematics_enrichment.VehicleStateIgnitionChange.VehicleStateLeaseDTO.avro18.topic"
      partitions         = 3
      replication_factor = 3
      config             = {}
    },
    {
      name               = "telematics_enrichment.Speeding.Trakm8DataDTO.avro18.topic"
      partitions         = 3
      replication_factor = 3
      config             = {}
    },
    {
      name               = "telematics_enrichment.ImprobableMappingDTO.avro18.topic"
      partitions         = 3
      replication_factor = 3
      config             = {}
    },
    {
      name               = "telematics_enrichment.AnonDriverDTO.avro18.topic"
      partitions         = 3
      replication_factor = 3
      config             = {}
    },
    {
      name               = "telematics_enrichment.LeaseMileageDTO.avro18.topic"
      partitions         = 3
      replication_factor = 3
      config             = {}
    },
    {
      name               = "telematics_enrichment.LeaseDynDbStreamEventDTO.avro18.DLQ_topic"
      partitions         = 3
      replication_factor = 3
      config             = {}
    },
    {
      name               = "epsagon-poc"
      partitions         = 3
      replication_factor = 3
      config             = {}
    },
    {
      name               = "telematics_enrichment.TripPathDTO.avro18.topic"
      partitions         = 3
      replication_factor = 3
      config             = {}
    },
    {
      name               = "telematics_enrichment.VehicleStateSummary.VehicleStateLeaseDTO.avro18.DLQ_topic"
      partitions         = 3
      replication_factor = 3
      config             = {}
    },
    {
      name               = "telematics_enrichment.SeverityMappingDTO.avro18.topic"
      partitions         = 3
      replication_factor = 3
      config             = {}
    },
    {
      name               = "telematics_enrichment.Flespi.Trakm8Calibration.json.topic"
      partitions         = 3
      replication_factor = 3
      config             = {}
    },
    {
      name               = "telematics_enrichment.VehicleStateLeaseDTO.avro18.topic"
      partitions         = 3
      replication_factor = 3
      config             = {}
    },
    {
      name               = "telematics_enrichment.VueHiResAccelDTO.avro18.topic"
      partitions         = 3
      replication_factor = 3
      config             = {}
    },
    {
      name               = "telematics_enrichment.Trakm8HarshCornering.json.DLQ_topic"
      partitions         = 3
      replication_factor = 3
      config             = {}
    },
    {
      name               = "telematics_enrichment.CalampGpsDTO.avro18.topic"
      partitions         = 3
      replication_factor = 3
      config             = {}
    },
    {
      name               = "telematics_enrichment.VehicleGpsDTO.avro18.DLQ_topic"
      partitions         = 3
      replication_factor = 3
      config             = {}
    },
    {
      name               = "telematics_enrichment.Trakm8HarshBraking.json.topic"
      partitions         = 3
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
      name               = "telematics_enrichment.Trakm8Gps.json.DLQ_topic"
      partitions         = 3
      replication_factor = 3
      config             = {}
    },
    {
      name               = "telematics_enrichment.CalampObd.json.topic"
      partitions         = 3
      replication_factor = 3
      config             = {}
    },
    {
      name               = "service_trip_enrichment.TripInfoDTO.avro18.topic"
      partitions         = 3
      replication_factor = 3
      config             = {}
    },

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
