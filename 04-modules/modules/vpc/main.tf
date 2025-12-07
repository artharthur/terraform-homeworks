# Модуль для создания сети с множественными подсетями
locals {
  network_name = "${var.env_name}-network"
  
  # Создаём список подсетей
  subnets_list = [
    for idx, subnet in var.subnets : {
      name = "${var.env_name}-subnet-${subnet.zone}"
      zone = subnet.zone
      cidr = subnet.cidr
    }
  ]
  
  # Создаём map подсетей для удобного доступа
  subnets_map = {
    for subnet in local.subnets_list :
    subnet.zone => subnet
  }
}
