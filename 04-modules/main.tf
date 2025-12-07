# Production VPC с 3 подсетями
module "vpc_prod" {
  source   = "./modules/vpc"
  env_name = "production"
  subnets = [
    { zone = "zone-a", cidr = "10.0.1.0/24" },
    { zone = "zone-b", cidr = "10.0.2.0/24" },
    { zone = "zone-c", cidr = "10.0.3.0/24" },
  ]
}

# Development VPC с 1 подсетью
module "vpc_dev" {
  source   = "./modules/vpc"
  env_name = "develop"
  subnets = [
    { zone = "zone-a", cidr = "192.168.1.0/24" },
  ]
}

# Marketing VM - используем develop vpc
module "marketing_vm" {
  source = "./modules/proxmox-lxc"
  
  node_name      = var.proxmox_node
  storage        = var.default_storage
  network_bridge = module.vpc_dev.network_bridge
  gateway        = var.container_gateway
  template_id    = "local:vztmpl/ubuntu-22.04-standard_22.04-1_amd64.tar.zst"
  
  instance_count = 2
  instance_name  = "web"
  project        = "marketing"
  env_name       = "prod"
  
  vm_id_start = 230
  ip_base     = "192.168.1"
  ip_start    = 230
  
  cpu_cores = 1
  memory    = 1024
  disk_size = 10
  
  ssh_public_key        = var.ssh_public_key
  ssh_private_key_path  = "~/.ssh/id_ed25519"
}

# Analytics VM - используем develop vpc
module "analytics_vm" {
  source = "./modules/proxmox-lxc"
  
  node_name      = var.proxmox_node
  storage        = var.default_storage
  network_bridge = module.vpc_dev.network_bridge
  gateway        = var.container_gateway
  template_id    = "local:vztmpl/ubuntu-22.04-standard_22.04-1_amd64.tar.zst"
  
  instance_count = 1
  instance_name  = "analytics"
  project        = "analytics"
  env_name       = "prod"
  
  vm_id_start = 232
  ip_base     = "192.168.1"
  ip_start    = 232
  
  cpu_cores = 2
  memory    = 2048
  disk_size = 15
  
  ssh_public_key        = var.ssh_public_key
  ssh_private_key_path  = "~/.ssh/id_ed25519"
}
