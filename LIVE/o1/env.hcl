locals {
  shutdown = false

  env = "o1"

  network = {
    name    = local.env
    domain  = "oracle.lh"
    macaddr = "52:54:60:02:00:%02x"
    subnet  = "10.60.2.0/24"
  }

  storage = {
    pool      = "vm_pool_${local.env}"
    directory = "/stor/libvirt/vm_pool_${local.env}"
  }

  nodes1 = {
    count   = 3
    prefix  = "${local.env}a"
    offset  = 10
    vcpu    = 2
    memory  = "2048"
    image   = "${get_parent_terragrunt_dir()}/../../packer/oracle/.cache/output/packer-oracle.qcow2"
    storage = "42949672960"  # 40GiB
    keys    = file("~/.ssh/id_rsa.pub")
  }

  nodes2 = {
    count   = 3
    prefix  = "${local.env}b"
    offset  = 20
    vcpu    = 2
    memory  = "3072"
    image   = "${get_parent_terragrunt_dir()}/../../packer/oracle/.cache/output/packer-oracle.qcow2"
    storage = "42949672960"  # 40GiB
    keys    = file("~/.ssh/id_rsa.pub")
  }
}
