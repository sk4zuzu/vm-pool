locals {
  shutdown = false

  env = "b1"

  network = {
    name    = local.env
    domain  = "freebsd.lh"
    macaddr = "52:54:02:01:10:%02x"
    subnet  = "10.2.110.0/24"
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
    image   = "${get_parent_terragrunt_dir()}/../../packer/freebsd/.cache/output/packer-freebsd.qcow2"
    storage = "12884901888"  # 12GiB
    keys    = file("~/.ssh/id_rsa.pub")
  }

  nodes2 = {
    count   = 2
    prefix  = "${local.env}b"
    offset  = 20
    vcpu    = 2
    memory  = "3072"
    image   = "${get_parent_terragrunt_dir()}/../../packer/freebsd/.cache/output/packer-freebsd.qcow2"
    storage = "12884901888"  # 12GiB
    keys    = file("~/.ssh/id_rsa.pub")
  }
}
