output "network_name" {
  description = "Network name"
  value       = local.network_name
}

output "network_bridge" {
  description = "Network bridge"
  value       = var.bridge
}

output "subnets" {
  description = "List of created subnets"
  value       = local.subnets_list
}

output "subnets_map" {
  description = "Map of subnets by zone"
  value       = local.subnets_map
}

output "subnet_count" {
  description = "Number of subnets"
  value       = length(var.subnets)
}
