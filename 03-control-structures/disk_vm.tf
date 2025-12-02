# Локальная переменная с конфигурацией дисков (для демонстрации dynamic)
locals {
  storage_disks = [
    { name = "disk1", size = 1 },
    { name = "disk2", size = 1 },
    { name = "disk3", size = 1 }
  ]
}

# Создание storage контейнера
resource "proxmox_virtual_environment_container" "storage" {
  node_name   = var.proxmox_node
  vm_id       = 225
  description = "storage-${join("-", [for d in local.storage_disks : d.name])}"
  
  operating_system {
    template_file_id = "local:vztmpl/ubuntu-22.04-standard_22.04-1_amd64.tar.zst"
  }
  
  cpu {
    cores = 2
  }
  
  memory {
    dedicated = 2048
  }
  
  # Основной диск увеличен до 15GB (вместо дополнительных дисков)
  disk {
    datastore_id = var.default_storage
    size         = 15
  }
  
  network_interface {
    name   = "eth0"
    bridge = var.network_bridge
  }
  
  initialization {
    hostname = "storage"
    
    ip_config {
      ipv4 {
        address = "192.168.1.225/24"
        gateway = var.container_gateway
      }
    }
    
    user_account {
      keys = [var.vms_ssh_root_key]
    }
  }
  
  features {
    nesting = true
  }
  
  unprivileged = true
  started      = true
}

# Output для storage с использованием for expression
output "storage_server" {
  description = "Storage сервер (демонстрация dynamic)"
  value = {
    vm_id       = proxmox_virtual_environment_container.storage.vm_id
    ip          = try(proxmox_virtual_environment_container.storage.initialization[0].ip_config[0].ipv4[0].address, "N/A")
    total_disk  = "15GB (1x основной вместо 1x10GB + 3x1GB)"
    disk_config = [for d in local.storage_disks : "${d.name}: ${d.size}GB"]
  }
}
