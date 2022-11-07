locals {
  shutdown = false

  env = "x1"

  network = {
    name    = local.env
    domain  = "nixos.lh"
    macaddr = "52:54:02:01:00:%02x"
    subnet  = "10.2.100.0/24"
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
    image   = "${get_parent_terragrunt_dir()}/../../packer/nixos/.cache/output/packer-nixos.qcow2"
    storage = "34359738368"  # 32GiB
    keys    = file("~/.ssh/id_rsa.pub")
  }

  nodes2 = {
    count   = 0
    prefix  = "${local.env}b"
    offset  = 20
    vcpu    = 2
    memory  = "3072"
    image   = "${get_parent_terragrunt_dir()}/../../packer/nixos/.cache/output/packer-nixos.qcow2"
    storage = "34359738368"  # 32GiB
    keys    = file("~/.ssh/id_rsa.pub")
  }
}
