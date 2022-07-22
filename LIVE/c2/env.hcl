locals {
  shutdown = false

  env = "c2"

  network = {
    name    = local.env
    domain  = "almalinux.lh"
    macaddr = "52:54:02:31:00:%02x"
    subnet  = "10.2.31.0/24"
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
    memory  = "2048"
    image   = "${get_parent_terragrunt_dir()}/../../packer/alma/.cache/output/packer-almalinux.qcow2"
    storage = "34359738368"  # 32GiB
    keys    = file("~/.ssh/id_rsa.pub")
  }

  nodes2 = {
    count   = 2
    prefix  = "${local.env}b"
    offset  = 20
    vcpu    = 2
    memory  = "4096"
    image   = "${get_parent_terragrunt_dir()}/../../packer/alma/.cache/output/packer-almalinux.qcow2"
    storage = "34359738368"  # 32GiB
    keys    = file("~/.ssh/id_rsa.pub")
  }
}
