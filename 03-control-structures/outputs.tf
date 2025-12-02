output "web_firewall_ip" {
  description = "IP адрес контейнера с firewall"
  value       = try(proxmox_virtual_environment_container.web_firewall.initialization[0].ip_config[0].ipv4[0].address, "N/A")
}

output "firewall_rules_count" {
  description = "Количество созданных правил"
  value = {
    ingress = length(var.firewall_rules_ingress)
    egress  = length(var.firewall_rules_egress)
  }
}

output "firewall_ingress_ports" {
  description = "Открытые входящие порты"
  value       = [for rule in var.firewall_rules_ingress : rule.dport if rule.dport != null]
}

# Задание 5*: Единый список всех VM
output "all_vms" {
  description = "Список всех созданных VM в едином формате"
  value = concat(
    # Web серверы (count)
    [
      for vm in proxmox_virtual_environment_container.web : {
        name = trimspace(vm.description)
        id   = vm.vm_id
        fqdn = "${vm.initialization[0].hostname}.local"
      }
    ],
    # БД серверы (for_each)
    [
      for k, vm in proxmox_virtual_environment_container.db : {
        name = "db-${k}"
        id   = vm.vm_id
        fqdn = "${vm.initialization[0].hostname}.local"
      }
    ],
    # Storage (одиночная VM)
    [{
      name = "storage"
      id   = proxmox_virtual_environment_container.storage.vm_id
      fqdn = "${proxmox_virtual_environment_container.storage.initialization[0].hostname}.local"
    }]
  )
}
