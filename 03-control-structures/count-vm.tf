# Переменные для web-серверов
locals {
  web_vm_count = 2
  web_vm_name  = "web"
}

# Создание web-серверов через count
resource "proxmox_virtual_environment_container" "web" {
  count = local.web_vm_count
  
  node_name   = var.proxmox_node
  vm_id       = 221 + count.index
  description = "${local.web_vm_name}-${count.index + 1}"
  
  operating_system {
    template_file_id = "local:vztmpl/ubuntu-22.04-standard_22.04-1_amd64.tar.zst"
  }
  
  cpu {
    cores = 1
  }
  
  memory {
    dedicated = 512
  }
  
  disk {
    datastore_id = var.default_storage
    size         = 8
  }
  
  network_interface {
    name   = "eth0"
    bridge = var.network_bridge
  }
  
  initialization {
    hostname = "${local.web_vm_name}-${count.index + 1}"
    
    ip_config {
      ipv4 {
        address = "192.168.1.${221 + count.index}/24"
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
  depends_on = [proxmox_virtual_environment_container.db]
}

# Output для web-серверов
output "web_servers" {
  description = "Web серверы созданные через count"
  value = {
    for idx, vm in proxmox_virtual_environment_container.web : 
      "web-${idx + 1}" => {
        vm_id = vm.vm_id
        ip    = try(vm.initialization[0].ip_config[0].ipv4[0].address, "N/A")
      }
  }
}
