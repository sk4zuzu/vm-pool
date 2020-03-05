
terraform {
    backend "local" {}
}

module "nodes1" {
    source = "./nodes/"

    asd_id   = var.asd_id
    ssh_keys = var.ssh_keys

    storage_pool = libvirt_pool.asd.name
    network_name = libvirt_network.asd.name

    subnet  = var.network["subnet"]
    macaddr = var.network["macaddr"]

    vcpu    = var.nodes1["vcpu"]
    memory  = var.nodes1["memory"]
    image   = var.nodes1["image"]
    storage = var.nodes1["storage"]

    _infix = "a"
    _ipgap = 10
    _count = var.nodes1["count"]
}

module "nodes2" {
    source = "./nodes/"

    asd_id   = var.asd_id
    ssh_keys = var.ssh_keys

    storage_pool = libvirt_pool.asd.name
    network_name = libvirt_network.asd.name

    subnet  = var.network["subnet"]
    macaddr = var.network["macaddr"]

    vcpu    = var.nodes2["vcpu"]
    memory  = var.nodes2["memory"]
    image   = var.nodes2["image"]
    storage = var.nodes2["storage"]

    _infix = "b"
    _ipgap = 20
    _count = var.nodes2["count"]
}

# vim:ts=4:sw=4:et:
