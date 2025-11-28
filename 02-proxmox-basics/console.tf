# Тестовые данные для работы в terraform console

variable "test_list" {
  type    = list(string)
  default = ["develop", "staging", "production"]
}

variable "test_map" {
  type = map(string)
  default = {
    admin    = "John"
    manager  = "Alice"
    engineer = "Bob"
  }
}

variable "servers" {
  type = map(object({
    cpu   = number
    ram   = number
    disks = number
    os    = string
  }))
  default = {
    production = {
      cpu   = 10
      ram   = 40
      disks = 4
      os    = "ubuntu-20-04"
    }
    staging = {
      cpu   = 4
      ram   = 16
      disks = 2
      os    = "ubuntu-22-04"
    }
  }
}
