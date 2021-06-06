variable "env" {
  type = string
}

variable "storage" {
  type = object({
    pool      = string
    directory = string
  })
}
