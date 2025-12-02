# Тестовая переменная для задания 7*
locals {
  vpc = {
    network_id = "network-12345"
    subnet_ids = [
      "subnet-a",
      "subnet-b",
      "subnet-c",
      "subnet-d",
    ]
    subnet_zones = [
      "zone-a",
      "zone-b", 
      "zone-c",
      "zone-d",
    ]
  }
}
