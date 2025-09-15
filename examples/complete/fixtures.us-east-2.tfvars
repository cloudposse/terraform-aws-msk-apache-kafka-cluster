region = "us-east-2"

namespace = "eg"

environment = "ue2"

stage = "test"

name = "msk-test"

availability_zones = ["us-east-2a", "us-east-2b"]

# https://docs.aws.amazon.com/msk/latest/developerguide/supported-kafka-versions.html
kafka_version = "3.4.0"

broker_per_zone = 2

broker_instance_type = "kafka.t3.small"

create_security_group = true

zone_name = "modules.cptest.test-automation.app"

# This variable specifies how many DNS records to create for the broker endpoints in the DNS zone provided in the `zone_id` variable.
# This corresponds to the total number of broker endpoints created by the module.
# Calculate this number by multiplying the `broker_per_zone` variable by the subnet count.
# This variable is necessary to prevent the Terraform error:
# The "count" value depends on resource attributes that cannot be determined until apply, so Terraform cannot predict how many instances will be created.
broker_dns_records_count = 4

# Unauthenticated cannot be set to `false` without enabling any authentication mechanisms
client_allow_unauthenticated = true
