# Proxmox connection
variable "proxmox_api_url" {
  description = "Proxmox API URL"
  type        = string
}

variable "proxmox_api_token" {
  description = "Proxmox API Token"
  type        = string
  sensitive   = true
}

variable "proxmox_node" {
  description = "Proxmox node name"
  type        = string
  default     = "pve"
}

# LXC container settings
variable "lxc_hostname" {
  description = "LXC container hostname"
  type        = string
  default     = "docker-host"
}

variable "lxc_vmid" {
  description = "LXC container VM ID"
  type        = number
  default     = 201
}

# SSH settings for remote Docker
variable "ssh_user" {
  description = "SSH user for LXC container"
  type        = string
  default     = "root"
}

variable "ssh_password" {
  description = "SSH password for LXC container"
  type        = string
  sensitive   = true
}
