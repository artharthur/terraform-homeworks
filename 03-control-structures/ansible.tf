# Локальные переменные для Ansible inventory
locals {
  # Web серверы (из count)
  webservers = [
  for i in proxmox_virtual_environment_container.web : {
    name = trimspace(i.description)
    ip   = replace(try(i.initialization[0].ip_config[0].ipv4[0].address, ""), "/24", "")
    fqdn = "${i.initialization[0].hostname}.local"
  }
]
  
  # БД серверы (из for_each)
  databases = [
    for k, v in proxmox_virtual_environment_container.db : {
      name = k
      ip   = replace(try(v.initialization[0].ip_config[0].ipv4[0].address, ""), "/24", "")
      fqdn = "${v.initialization[0].hostname}.local"
    }
  ]
  
  # Storage сервер
  storage = [{
    name = "storage"
    ip   = replace(try(proxmox_virtual_environment_container.storage.initialization[0].ip_config[0].ipv4[0].address, ""), "/24", "")
    fqdn = "${proxmox_virtual_environment_container.storage.initialization[0].hostname}.local"
  }]
}

# Генерация inventory файла через templatefile
resource "local_file" "ansible_inventory" {
  content = templatefile("${path.module}/hosts.tftpl", {
    webservers = local.webservers
    databases  = local.databases
    storage    = local.storage
  })
  
  filename = "${path.module}/hosts.ini"
}

# Output для проверки inventory
output "ansible_inventory_path" {
  description = "Путь к сгенерированному Ansible inventory"
  value       = abspath(local_file.ansible_inventory.filename)
}
