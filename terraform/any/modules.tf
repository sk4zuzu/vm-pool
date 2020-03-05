
terraform {
    backend "local" {}
}

module "nodes" {
    source = "./nodes/"

    any_id   = var.any_id
    ssh_keys = var.ssh_keys

    storage_pool = libvirt_pool.any.name
    network_name = libvirt_network.any.name

    subnet  = var.network["subnet"]
    macaddr = var.network["macaddr"]

    vcpu    = var.nodes["vcpu"]
    memory  = var.nodes["memory"]
    image   = var.nodes["image"]
    storage = var.nodes["storage"]

    _count = var.nodes["count"]
}

# vim:ts=4:sw=4:et:
