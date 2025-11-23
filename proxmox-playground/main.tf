# Тестовый LXC контейнер
resource "proxmox_virtual_environment_container" "test_container" {
  description = "Managed by Terraform"

  node_name = var.proxmox_node
  vm_id     = 200

  initialization {
    hostname = "terraform-test"
    
    ip_config {
      ipv4 {
        address = "dhcp"
      }
    }
    
    user_account {
      keys     = []
      password = "test123"
    }
  }

  network_interface {
    name   = "eth0"
    bridge = "vmbr0"
  }

  disk {
    datastore_id = "local-lvm"
    size         = 8
  }

  operating_system {
    template_file_id = "local:vztmpl/ubuntu-22.04-standard_22.04-1_amd64.tar.zst"
    type             = "ubuntu"
  }

  cpu {
    cores = 1
  }

  memory {
    dedicated = 512
  }

  start_on_boot = false
  started       = true
}
