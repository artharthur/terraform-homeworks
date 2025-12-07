variable "env_name" {
  description = "Environment name (develop, stage, prod)"
  type        = string
}

variable "subnets" {
  description = "List of subnets to create"
  type = list(object({
    zone = string
    cidr = string
  }))
}

variable "bridge" {
  description = "Proxmox network bridge"
  type        = string
  default     = "vmbr0"
}
