resource "proxmox_virtual_environment_container" "docker_host" {
  description = "Docker Host managed by Terraform"
  
  node_name = var.proxmox_node
  vm_id     = var.lxc_vmid
  unprivileged = true
  
  initialization {
    hostname = var.lxc_hostname
    
    ip_config {
      ipv4 {
        address = "192.168.1.70/24"
        gateway = "192.168.1.1"
      }
    }
    
    user_account {
      keys     = []
      password = var.ssh_password
    }
  }
  
  network_interface {
    name   = "eth0"
    bridge = "vmbr0"
  }
  
  disk {
    datastore_id = "local-lvm"
    size         = 16
  }
  
  operating_system {
    template_file_id = "local:vztmpl/ubuntu-22.04-standard_22.04-1_amd64.tar.zst"
    type             = "ubuntu"
  }
  
  cpu {
    cores = 2
  }
  
  memory {
    dedicated = 2048
  }
  
  start_on_boot = false
  started       = true
  
  features {
    nesting = true
  }
}

# Настройка LXC для Docker
resource "null_resource" "configure_lxc" {
  depends_on = [proxmox_virtual_environment_container.docker_host]
  
  triggers = {
    container_id = proxmox_virtual_environment_container.docker_host.id
  }
  
  provisioner "local-exec" {
    command = <<-EOT
      ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null root@192.168.1.83 '
        pct stop 201
        echo "lxc.apparmor.profile: unconfined" >> /etc/pve/lxc/201.conf
        echo "lxc.cgroup2.devices.allow: a" >> /etc/pve/lxc/201.conf
        echo "lxc.cap.drop:" >> /etc/pve/lxc/201.conf
        pct start 201
        sleep 20
      '
    EOT
  }
}

# Установка SSH + Docker
resource "null_resource" "install_ssh_and_docker" {
  depends_on = [null_resource.configure_lxc]
  
  triggers = {
    container_id = proxmox_virtual_environment_container.docker_host.id
  }
  
  # Устанавливаем через pct exec (не требует SSH)
  provisioner "local-exec" {
    command = <<-EOT
      ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null root@192.168.1.83 '
        echo "=== Installing SSH ==="
        pct exec 201 -- bash -c "apt-get update -qq && DEBIAN_FRONTEND=noninteractive apt-get install -y -qq openssh-server"
        pct exec 201 -- bash -c "systemctl enable ssh && systemctl start ssh"
        echo "=== SSH installed ==="
        sleep 10
        
        echo "=== Installing Docker prerequisites ==="
        pct exec 201 -- bash -c "DEBIAN_FRONTEND=noninteractive apt-get install -y -qq ca-certificates curl gnupg lsb-release"
        
        echo "=== Adding Docker GPG key ==="
        pct exec 201 -- bash -c "install -m 0755 -d /etc/apt/keyrings"
        pct exec 201 -- bash -c "curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg"
        pct exec 201 -- bash -c "chmod a+r /etc/apt/keyrings/docker.gpg"
        
        echo "=== Adding Docker repository ==="
        pct exec 201 -- bash -c "echo \"deb [arch=\$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \$(. /etc/os-release && echo \$VERSION_CODENAME) stable\" > /etc/apt/sources.list.d/docker.list"
        
        echo "=== Installing Docker ==="
        pct exec 201 -- bash -c "apt-get update -qq"
        pct exec 201 -- bash -c "DEBIAN_FRONTEND=noninteractive apt-get install -y -qq docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin"
        
        echo "=== Starting Docker ==="
        pct exec 201 -- bash -c "systemctl enable docker && systemctl start docker"
        
        echo "=== Docker installed! ==="
        pct exec 201 -- bash -c "docker --version"
      '
    EOT
  }
}

resource "random_password" "mysql_root_password" {
  length      = 16
  special     = true
  min_upper   = 2
  min_lower   = 2
  min_numeric = 2
  min_special = 2
}

resource "random_password" "mysql_user_password" {
  length      = 16
  special     = true
  min_upper   = 2
  min_lower   = 2
  min_numeric = 2
  min_special = 2
}

# ========================================
# Docker Provider для remote подключения
# ========================================

provider "docker" {
  host = "ssh://root@192.168.1.70:22"
  
  ssh_opts = [
    "-o", "StrictHostKeyChecking=no",
    "-o", "UserKnownHostsFile=/dev/null"
  ]
}

# ========================================
# MySQL Docker контейнер
# ========================================

resource "docker_image" "mysql" {
  name         = "mysql:8"
  keep_locally = true
}

resource "docker_container" "mysql" {
  name  = "mysql-terraform"
  image = docker_image.mysql.image_id
  
  security_opts = ["apparmor=unconfined"]

  env = [
    "MYSQL_ROOT_PASSWORD=${random_password.mysql_root_password.result}",
    "MYSQL_DATABASE=wordpress",
    "MYSQL_USER=wordpress",
    "MYSQL_PASSWORD=${random_password.mysql_user_password.result}",
    "MYSQL_ROOT_HOST=%"
  ]
  
  ports {
    internal = 3306
    external = 3306
    ip       = "127.0.0.1"
  }
  
  restart = "unless-stopped"
}
