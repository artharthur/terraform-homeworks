# Создание LXC контейнера из template (аналог yandex_compute_instance)
resource "proxmox_virtual_environment_container" "platform" {
  # ОШИБКА 1: неправильное имя ноды (должно быть var.proxmox_node)
  node_name = var.proxmox_node
  
  vm_id = var.vm_web_vmid 
  description = local.vm_web_name
  
  # Создание из template Ubuntu 22.04
  operating_system {
    template_file_id = "local:vztmpl/ubuntu-22.04-standard_22.04-1_amd64.tar.zst"
  }
  
  # ОШИБКА 2: память должна быть в мегабайтах (1024, а не 1)
  cpu {
    cores = var.vms_resources["web"].cores 
  }
  
  memory {
    dedicated = var.vms_resources["web"].memory 
  }
  
  # Disk
  disk {
    datastore_id = var.default_storage
    size         = var.vms_resources["web"].disk_size 
  }
  
  # ОШИБКА 3: IP должен быть в формате CIDR с /24
  network_interface {
    name = "eth0"
    bridge = var.network_bridge
  }
  
  initialization {
    hostname = local.vm_web_name
    
    ip_config {
      ipv4 {
        address = var.vm_web_ip
        gateway = var.container_gateway
      }
    }
    
    user_account {
      keys = [var.vms_ssh_root_key]
    }
  }
  
  # Features
  features {
    nesting = true
  }
  
  unprivileged = true

  # Запуск (аналог preemptible)
  started = true
}

# Создание второго LXC контейнера - database
resource "proxmox_virtual_environment_container" "platform_db" {
  node_name   = var.proxmox_node
  vm_id       = var.vm_db_vmid
  description = local.vm_db_name
  
  # Создание из template Ubuntu 22.04
  operating_system {
    template_file_id = "local:vztmpl/ubuntu-22.04-standard_22.04-1_amd64.tar.zst"
  }
  
  cpu {
    cores = var.vms_resources["db"].cores
  }
  
  memory {
    dedicated = var.vms_resources["db"].memory
  }
  
  # Disk
  disk {
    datastore_id = var.default_storage
    size         = var.vms_resources["db"].disk_size
  }
  
  network_interface {
    name   = "eth0"
    bridge = var.network_bridge
  }
  
  initialization {
    hostname = local.vm_db_name
    
    ip_config {
      ipv4 {
        address = var.vm_db_ip
        gateway = var.container_gateway
      }
    }
    
    user_account {
      keys = [var.vms_ssh_root_key]
    }
  }
  
  # Features
  features {
    nesting = true
  }
  
  unprivileged = true
  
  # Запуск
  started = true
}
