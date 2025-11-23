provider "proxmox" {
  endpoint = var.proxmox_api_url
  
  api_token = var.proxmox_api_token
  
  # Самоподписанный сертификат
  insecure = true
  
  # SSH для некоторых операций (опционально)
  ssh {
    agent = true
  }
}