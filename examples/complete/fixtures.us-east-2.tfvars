enabled = true

namespace = "eg"

environment = "ue2"

stage = "test"

name = "msk-test"

delimiter = "-"

zone_id = "Z0000XXXXXXXXX"

availability_zones = ["us-east-2a", "us-east-2b", "us-east-2c"]

kafka_version = "2.4.1"

number_of_broker_nodes = 3

broker_instance_type = "kafka.m5.large"
