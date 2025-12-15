variable "proxmox_api_url" {
  type        = string
  description = "Proxmox API URL"
}

variable "proxmox_api_token" {
  type        = string
  description = "Proxmox API Token"
  sensitive   = true
}

variable "proxmox_node" {
  type        = string
  description = "Proxmox node name"
}

variable "default_storage" {
  type        = string
  default     = "local-lvm"
  description = "Default storage"
}

variable "container_gateway" {
  type        = string
  default     = "192.168.1.1"
  description = "Network gateway"
}

variable "ssh_public_key" {
  type        = string
  description = "SSH public key"
}
