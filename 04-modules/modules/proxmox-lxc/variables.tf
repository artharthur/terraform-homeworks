variable "node_name" {
  description = "Proxmox node name"
  type        = string
}

variable "storage" {
  description = "Storage name"
  type        = string
  default     = "local-lvm"
}

variable "network_bridge" {
  description = "Network bridge"
  type        = string
  default     = "vmbr0"
}

variable "gateway" {
  description = "Network gateway"
  type        = string
}

variable "template_id" {
  description = "LXC template ID"
  type        = string
}

variable "instance_count" {
  description = "Number of instances"
  type        = number
  default     = 1
}

variable "instance_name" {
  description = "Instance name prefix"
  type        = string
}

variable "project" {
  description = "Project label"
  type        = string
}

variable "env_name" {
  description = "Environment name"
  type        = string
  default     = "prod"
}

variable "vm_id_start" {
  description = "Starting VM ID"
  type        = number
}

variable "ip_base" {
  description = "IP base (192.168.1)"
  type        = string
}

variable "ip_start" {
  description = "Starting IP last octet"
  type        = number
}

variable "cpu_cores" {
  description = "CPU cores"
  type        = number
  default     = 1
}

variable "memory" {
  description = "Memory in MB"
  type        = number
  default     = 1024
}

variable "disk_size" {
  description = "Disk size in GB"
  type        = number
  default     = 8
}

variable "ssh_public_key" {
  description = "SSH public key"
  type        = string
}

variable "cloud_init_id" {
  description = "Cloud-init file ID"
  type        = string
  default     = ""
}

variable "ssh_private_key_path" {
  description = "Path to SSH private key"
  type        = string
  default     = "~/.ssh/id_ed25519"
}
