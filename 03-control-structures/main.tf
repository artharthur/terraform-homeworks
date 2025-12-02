# Создаём LXC контейнер для демонстрации firewall
resource "proxmox_virtual_environment_container" "web_firewall" {
  node_name   = var.proxmox_node
  vm_id       = 220
  description = "web-server-with-firewall"
  
  operating_system {
    template_file_id = "local:vztmpl/ubuntu-22.04-standard_22.04-1_amd64.tar.zst"
  }
  
  cpu {
    cores = 1
  }
  
  memory {
    dedicated = 1024
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
    hostname = "web-firewall"
    
    ip_config {
      ipv4 {
        address = "192.168.1.220/24"
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

# Применяем firewall правила с использованием dynamic блоков
resource "proxmox_virtual_environment_firewall_rules" "web_firewall_rules" {
  node_name     = var.proxmox_node
  container_id  = proxmox_virtual_environment_container.web_firewall.vm_id
  
  # Динамический блок для входящих правил
  dynamic "rule" {
    for_each = var.firewall_rules_ingress
    content {
      type    = "in"
      action  = rule.value.action
      comment = rule.value.comment
      proto   = rule.value.proto
      dport   = lookup(rule.value, "dport", null)
      source  = lookup(rule.value, "source", null)
      enabled = true
    }
  }
  
  # Динамический блок для исходящих правил
  dynamic "rule" {
    for_each = var.firewall_rules_egress
    content {
      type    = "out"
      action  = rule.value.action
      comment = rule.value.comment
      proto   = rule.value.proto
      dport   = lookup(rule.value, "dport", null)
      dest    = lookup(rule.value, "dest", null)
      enabled = true
    }
  }
}
