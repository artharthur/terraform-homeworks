# Сводная информация о всех контейнерах
output "containers_info" {
  description = "Information about all containers"
  value = {
    web = {
      instance_name = proxmox_virtual_environment_container.platform.description
      internal_ip   = try(proxmox_virtual_environment_container.platform.initialization[0].ip_config[0].ipv4[0].address, "N/A")
      hostname      = try(proxmox_virtual_environment_container.platform.initialization[0].hostname, "N/A")
    }
    db = {
      instance_name = proxmox_virtual_environment_container.platform_db.description
      internal_ip   = try(proxmox_virtual_environment_container.platform_db.initialization[0].ip_config[0].ipv4[0].address, "N/A")
      hostname      = try(proxmox_virtual_environment_container.platform_db.initialization[0].hostname, "N/A")
    }
  }
}
