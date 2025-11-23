output "lxc_container_id" {
  description = "LXC Container ID"
  value       = proxmox_virtual_environment_container.docker_host.vm_id
}

output "lxc_container_ip" {
  description = "LXC Container IP address"
  value       = proxmox_virtual_environment_container.docker_host.initialization[0].ip_config[0].ipv4[0].address
}

output "lxc_hostname" {
  description = "LXC Container hostname"
  value       = proxmox_virtual_environment_container.docker_host.initialization[0].hostname
}

output "mysql_root_password" {
  description = "MySQL root password (sensitive)"
  value       = random_password.mysql_root_password.result
  sensitive   = true
}

output "mysql_user_password" {
  description = "MySQL user password (sensitive)"
  value       = random_password.mysql_user_password.result
  sensitive   = true
}

output "ssh_command" {
  description = "SSH command to connect to container"
  value       = "ssh ${var.ssh_user}@${proxmox_virtual_environment_container.docker_host.initialization[0].ip_config[0].ipv4[0].address}"
}
