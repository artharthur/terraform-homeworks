output "vm_ids" {
  description = "VM IDs"
  value       = proxmox_virtual_environment_container.this[*].vm_id
}

output "ip_addresses" {
  description = "IP addresses"
  value       = [
    for vm in proxmox_virtual_environment_container.this :
    try(vm.initialization[0].ip_config[0].ipv4[0].address, "N/A")
  ]
}

output "names" {
  description = "Container names"
  value       = proxmox_virtual_environment_container.this[*].description
}
