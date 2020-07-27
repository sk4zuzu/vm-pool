
variable "qwe_id" {
    type = string
}

variable "ssh_keys" {
    type = list
}

variable "storage_pool" {
    type = string
}

variable "network_name" {
    type = string
}

variable "subnet" {
    type = string
}

variable "macaddr" {
    type = string
}

variable "vcpu" {
    type = string
}

variable "memory" {
    type = string
}

variable "image" {
    type = string
}

variable "storage" {
    type = string
}

variable "shutdown" {
    type = bool
    default = false
}

variable "_infix" {
    type = string
}

variable "_ipgap" {
    type = number
}

variable "_count" {
    type = number
}

# vim:ts=4:sw=4:et:
