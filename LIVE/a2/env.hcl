locals {
  shutdown = false

  env = "a2"

  network = {
    name    = local.env
    domain  = "void.lh"
    macaddr = "52:54:02:00:21:%02x"
    subnet  = "10.2.21.0/24"
  }

  storage = {
    pool      = "vm_pool_${local.env}"
    directory = "/stor/libvirt/vm_pool_${local.env}"
  }

  nodes1 = {
    count   = 2
    prefix  = "${local.env}a"
    offset  = 10
    vcpu    = 2
    memory  = "2048"
    image   = "${get_parent_terragrunt_dir()}/../../packer/void/.cache/output/packer-void.qcow2"
    storage = "12884901888"  # 12GiB
    keys    = file("~/.ssh/id_rsa.pub")
  }

  nodes2 = {
    count   = 0
    prefix  = "${local.env}b"
    offset  = 20
    vcpu    = 2
    memory  = "2048"
    image   = "${get_parent_terragrunt_dir()}/../../packer/void/.cache/output/packer-void.qcow2"
    storage = "12884901888"  # 12GiB
    keys    = file("~/.ssh/id_rsa.pub")
  }
}
