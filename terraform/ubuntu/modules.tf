terraform {
  backend "local" {}
}

module "nodes1" {
  source = "./nodes/"

  env_id   = var.env_id
  ssh_keys = var.ssh_keys

  storage_pool = libvirt_pool.ubuntu.name
  network_name = libvirt_network.ubuntu.name

  subnet  = var.network["subnet"]
  macaddr = var.network["macaddr"]

  vcpu    = var.nodes1["vcpu"]
  memory  = var.nodes1["memory"]
  image   = var.nodes1["image"]
  storage = var.nodes1["storage"]

  shutdown = var.shutdown

  _infix = "a"
  _ipgap = 10
  _count = var.nodes1["count"]
}

module "nodes2" {
  source = "./nodes/"

  env_id   = var.env_id
  ssh_keys = var.ssh_keys

  storage_pool = libvirt_pool.ubuntu.name
  network_name = libvirt_network.ubuntu.name

  subnet  = var.network["subnet"]
  macaddr = var.network["macaddr"]

  vcpu    = var.nodes2["vcpu"]
  memory  = var.nodes2["memory"]
  image   = var.nodes2["image"]
  storage = var.nodes2["storage"]

  shutdown = var.shutdown

  _infix = "b"
  _ipgap = 20
  _count = var.nodes2["count"]
}
