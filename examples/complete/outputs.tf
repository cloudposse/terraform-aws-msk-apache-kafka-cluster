output "cluster_arn" {
  description = "Amazon Resource Name (ARN) of the MSK cluster"
  value       = module.kafka.cluster_arn
}

output "config_arn" {
  description = "Amazon Resource Name (ARN) of the MSK configuration"
  value       = module.kafka.config_arn
}

//output "hostname" {
//  description = "DNS hostname of MSK cluster"
//  value       = module.kafka.hostname
//}
