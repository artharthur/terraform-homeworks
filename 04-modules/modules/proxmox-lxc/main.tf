# Модуль для создания LXC контейнера в Proxmox
terraform {
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "~> 0.71.0"
    }
  }
}

resource "proxmox_virtual_environment_container" "this" {
  count = var.instance_count
  
  node_name   = var.node_name
  vm_id       = var.vm_id_start + count.index
  description = "${var.project}-${var.instance_name}-${count.index + 1}"
  
  operating_system {
    template_file_id = var.template_id
  }
  
  cpu {
    cores = var.cpu_cores
  }
  
  memory {
    dedicated = var.memory
  }
  
  disk {
    datastore_id = var.storage
    size         = var.disk_size
  }
  
  network_interface {
    name   = "eth0"
    bridge = var.network_bridge
  }
  
  initialization {
    hostname = "${var.project}-${var.instance_name}-${count.index + 1}"
    
    ip_config {
      ipv4 {
        address = "${var.ip_base}.${var.ip_start + count.index}/24"
        gateway = var.gateway
      }
    }
    
    user_account {
      keys = [var.ssh_public_key]
    }
  }
  
  tags = [var.project, var.env_name]
  
  features {
    nesting = true
  }
  
  unprivileged = true
  started      = true
  
  lifecycle {
    ignore_changes = [
      operating_system,
      network_interface[0].mac_address
    ]
  }

  # Установка nginx через provisioner
#  connection {
#    type     = "ssh"
#    user     = "root"
#    host     = replace(self.initialization[0].ip_config[0].ipv4[0].address, "/24", "")
#    private_key = file(var.ssh_private_key_path)
#  }
  
#  provisioner "remote-exec" {
#    inline = [
#      "sleep 10",  # Даём время на запуск контейнера
#      "apt-get update",
#      "DEBIAN_FRONTEND=noninteractive apt-get install -y nginx",
#      "systemctl enable nginx",
#      "systemctl start nginx"
#    ]
#  }
}
