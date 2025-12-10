variable "env" {
  type = string
}

variable "running" {
  type    = bool
  default = true
}

variable "network" {
  type = object({
    name    = string
    domain  = string
    subnet  = string
    macaddr = string
  })
}

variable "storage" {
  type = object({
    pool      = string
    directory = string
  })
}

variable "nodes" {
  type = object({
    count   = number
    prefix  = string
    offset  = number
    vcpu    = number
    memory  = string
    image   = string
    storage = string
    keys    = string
  })
}
