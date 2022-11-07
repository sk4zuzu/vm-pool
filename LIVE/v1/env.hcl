locals {
  shutdown = false

  env = "v1"

  network = {
    name    = local.env
    domain  = "libvirt.lh"
    macaddr = "52:54:02:00:51:%02x"
    subnet  = "10.2.51.0/24"
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
    memory  = "8192"
    image   = "${get_parent_terragrunt_dir()}/../../packer/libvirt/.cache/output/packer-libvirt.qcow2"
    storage = "34359738368"  # 32GiB
    keys    = file("~/.ssh/id_rsa.pub")
  }

  nodes2 = {
    count   = 1
    prefix  = "${local.env}b"
    offset  = 20
    vcpu    = 2
    memory  = "2048"
    image   = "${get_parent_terragrunt_dir()}/../../packer/ubuntu/.cache/output/packer-ubuntu.qcow2"
    storage = "34359738368"  # 32GiB
    keys    = file("~/.ssh/id_rsa.pub")
  }
}
