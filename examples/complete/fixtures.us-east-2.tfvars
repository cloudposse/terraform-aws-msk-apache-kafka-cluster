region = "us-east-2"

namespace = "eg"

environment = "ue2"

stage = "test"

name = "msk-test"

zone_id = "Z3SO0TKDDQ0RGG"

availability_zones = ["us-east-2a", "us-east-2b"]

# https://docs.aws.amazon.com/msk/latest/developerguide/supported-kafka-versions.html
kafka_version = "3.3.2"

broker_per_zone = 2

broker_instance_type = "kafka.t3.small"

create_security_group = true
