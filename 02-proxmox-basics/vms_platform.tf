###vm_web vars

variable "vm_web_name" {
  type        = string
  default     = ""
  description = "VM/Container name"
}

variable "vm_web_vmid" {
  type        = number
  default     = 210
  description = "VM ID"
}

#variable "vm_web_cores" {
#  type        = number
#  default     = 1
#  description = "CPU cores"
#}

#variable "vm_web_memory" {
#  type        = number
#  default     = 1024
#  description = "Memory in MB"
#}

#variable "vm_web_disk_size" {
#  type        = number
#  default     = 8
#  description = "Disk size in GB"
#}

variable "vm_web_ip" {
  type        = string
  default     = "192.168.1.210/24"
  description = "IP address with CIDR mask"
}

###vm_db vars

variable "vm_db_name" {
  type        = string
  default     = ""
  description = "DB VM/Container name"
}

variable "vm_db_vmid" {
  type        = number
  default     = 211
  description = "DB VM ID"
}

#variable "vm_db_cores" {
#  type        = number
#  default     = 2
#  description = "DB CPU cores"
#}

#variable "vm_db_memory" {
#  type        = number
#  default     = 2048
#  description = "DB Memory in MB (2 GB)"
#}

#variable "vm_db_disk_size" {
#  type        = number
#  default     = 8
#  description = "DB Disk size in GB"
#}

variable "vm_db_ip" {
  type        = string
  default     = "192.168.1.211/24"
  description = "DB IP address with CIDR mask"
}

###vms_resources - объединённые параметры ресурсов

variable "vms_resources" {
  type = map(object({
    cores      = number
    memory     = number
    disk_size  = number
  }))
  description = "Resources for VMs/Containers"
}
