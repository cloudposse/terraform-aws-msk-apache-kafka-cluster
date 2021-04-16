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
        (Optional) - The data source resource configuration which allows a data source to be created on a Grafana server.
            name - (Required) The name of the topic..
            partitions - (Required) The number of partitions the topic should have.
            replication_factor - (Required) The number of replicas the topic should have.
            config - (Optional) A map of string k/v attributes.
    EOT
}

variable "bootstrap_servers" {
  type        = list(string)
  description = "(Required) A list of host:port addresses that will be used to discover the full set of alive brokers."
}
