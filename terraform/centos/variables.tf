variable "env_id" {
  type = string
}

variable "ssh_keys" {
  type = list
}

variable "pool_directory" {
  type = string
}

variable "network" {
  type = map
}

variable "nodes1" {
  type = map
}

variable "nodes2" {
  type = map
}

variable "shutdown" {
  type = bool
  default = false
}
