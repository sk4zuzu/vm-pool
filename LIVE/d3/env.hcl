locals {
  shutdown = false

  env = "d3"

  network = {
    name    = local.env
    domain  = "debian.lh"
    macaddr = "52:54:02:00:83:%02x"
    subnet  = "10.2.83.0/24"
  }

  storage = {
    pool      = "vm_pool_${local.env}"
    directory = "/stor/libvirt/vm_pool_${local.env}"
  }

  nodes1 = {
    count   = 1
    prefix  = "${local.env}a"
    offset  = 10
    vcpu    = 2
    memory  = "3072"
    image   = "${get_parent_terragrunt_dir()}/../../packer/debian32/.cache/output/packer-debian32.qcow2"
    storage = "34359738368"  # 32GiB
    keys    = file("~/.ssh/id_rsa.pub")
  }

  nodes2 = {
    count   = 0
    prefix  = "${local.env}b"
    offset  = 20
    vcpu    = 2
    memory  = "2048"
    image   = "${get_parent_terragrunt_dir()}/../../packer/debian32/.cache/output/packer-debian32.qcow2"
    storage = "34359738368"  # 32GiB
    keys    = file("~/.ssh/id_rsa.pub")
  }
}
