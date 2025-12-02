# Переменная для БД серверов
variable "each_vm" {
  type = list(object({
    vm_name     = string
    cpu         = number
    ram         = number
    disk_volume = number
  }))
  default = [
    {
      vm_name     = "main"
      cpu         = 2
      ram         = 2048
      disk_volume = 10
    },
    {
      vm_name     = "replica"
      cpu         = 1
      ram         = 1024
      disk_volume = 8
    }
  ]
}

# Создание БД серверов через for_each
resource "proxmox_virtual_environment_container" "db" {
  for_each = { for idx, vm in var.each_vm : vm.vm_name => vm }
  
  node_name   = var.proxmox_node
  vm_id       = 223 + index(var.each_vm[*].vm_name, each.key)
  description = "db-${each.value.vm_name}"
  
  operating_system {
    template_file_id = "local:vztmpl/ubuntu-22.04-standard_22.04-1_amd64.tar.zst"
  }
  
  cpu {
    cores = each.value.cpu
  }
  
  memory {
    dedicated = each.value.ram
  }
  
  disk {
    datastore_id = var.default_storage
    size         = each.value.disk_volume
  }
  
  network_interface {
    name   = "eth0"
    bridge = var.network_bridge
  }
  
  initialization {
    hostname = "db-${each.value.vm_name}"
    
    ip_config {
      ipv4 {
        address = "192.168.1.${223 + index(var.each_vm[*].vm_name, each.key)}/24"
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
  
  # ЗАДАНИЕ 2.4: Зависимость - БД создаются ПЕРЕД web
  # (web будут зависеть от БД в следующем шаге)
}

# Output для БД серверов
output "db_servers" {
  description = "БД серверы созданные через for_each"
  value = {
    for name, vm in proxmox_virtual_environment_container.db :
      name => {
        vm_id = vm.vm_id
        ip    = try(vm.initialization[0].ip_config[0].ipv4[0].address, "N/A")
        cpu   = vm.cpu[0].cores
        ram   = vm.memory[0].dedicated
      }
  }
}
