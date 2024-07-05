variable "env" {
  type = string
}

variable "network" {
  type = object({
    name    = string
    domain  = string
    subnet  = string
    macaddr = string
  })
}

variable "nodes1" {
  type = object({
    count   = number
    prefix  = string
    offset  = number
    vcpu    = number
    memory  = string
    image   = string
    storage = string
  })
  default = {
    count   = 0
    prefix  = null
    offset  = null
    vcpu    = null
    memory  = null
    image   = null
    storage = null
  }
}

variable "nodes2" {
  type = object({
    count   = number
    prefix  = string
    offset  = number
    vcpu    = number
    memory  = string
    image   = string
    storage = string
  })
  default = {
    count   = 0
    prefix  = null
    offset  = null
    vcpu    = null
    memory  = null
    image   = null
    storage = null
  }
}
