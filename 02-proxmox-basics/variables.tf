###proxmox vars

variable "proxmox_api_url" {
  type        = string
  description = "Proxmox API URL"
}

variable "proxmox_api_token" {
  type        = string
  sensitive   = true
  description = "Proxmox API Token (format: user@realm!tokenid=secret)"
}

variable "proxmox_node" {
  type        = string
  default     = "pve"
  description = "Proxmox node name"
}

variable "default_storage" {
  type        = string
  default     = "local-lvm"
  description = "Storage for container rootfs"
}

###network vars

variable "network_bridge" {
  type        = string
  default     = "vmbr0"
  description = "Network bridge name"
}

variable "container_gateway" {
  type        = string
  default     = "192.168.1.1"
  description = "Network gateway"
}

###ssh vars

variable "vms_ssh_root_key" {
  type        = string
  description = "SSH public key for root access"
}

###metadata - общие метаданные для всех VM

variable "vm_metadata" {
  type = map(string)
  description = "Common metadata for all VMs"
}
