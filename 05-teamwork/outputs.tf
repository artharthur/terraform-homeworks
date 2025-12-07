output "marketing_vms" {
  description = "Marketing VMs info"
  value = {
    vm_ids = module.marketing_vm.vm_ids
    ips    = module.marketing_vm.ip_addresses
    names  = module.marketing_vm.names
  }
}

output "analytics_vms" {
  description = "Analytics VMs info"
  value = {
    vm_ids = module.analytics_vm.vm_ids
    ips    = module.analytics_vm.ip_addresses
    names  = module.analytics_vm.names
  }
}

output "vpc_prod" {
  description = "Production VPC with multiple subnets"
  value       = module.vpc_prod
}

output "vpc_dev" {
  description = "Development VPC"
  value       = module.vpc_dev
}
