# Переменные для входящих правил firewall
variable "firewall_rules_ingress" {
  description = "Входящие firewall правила"
  type = list(object({
    action  = string
    comment = string
    dport   = optional(string)
    proto   = string
    source  = optional(string)
  }))
  default = [
    {
      action  = "ACCEPT"
      comment = "Разрешить SSH"
      proto   = "tcp"
      dport   = "22"
      source  = "0.0.0.0/0"
    },
    {
      action  = "ACCEPT"
      comment = "Разрешить HTTP"
      proto   = "tcp"
      dport   = "80"
      source  = "0.0.0.0/0"
    },
    {
      action  = "ACCEPT"
      comment = "Разрешить HTTPS"
      proto   = "tcp"
      dport   = "443"
      source  = "0.0.0.0/0"
    }
  ]
}

# Переменные для исходящих правил firewall
variable "firewall_rules_egress" {
  description = "Исходящие firewall правила"
  type = list(object({
    action  = string
    comment = string
    dport   = optional(string)
    proto   = string
    dest    = optional(string)
  }))
  default = [
    {
      action  = "ACCEPT"
      comment = "Разрешить весь исходящий трафик"
      proto   = "tcp"
      dest    = "0.0.0.0/0"
    }
  ]
}
