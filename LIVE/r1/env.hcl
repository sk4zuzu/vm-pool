locals {
  shutdown = false

  env = "r1"

  network = {
    name    = local.env
    domain  = "redhat.lh"
    macaddr = "52:54:40:02:00:%02x"
    subnet  = "10.40.2.0/24"
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
    image   = "${get_parent_terragrunt_dir()}/../../packer/redhat/.cache/output/packer-redhat.qcow2"
    storage = "34359738368"  # 32GiB
    keys    = file("~/.ssh/id_rsa.pub")
  }

  nodes2 = {
    count   = 3
    prefix  = "${local.env}b"
    offset  = 20
    vcpu    = 2
    memory  = "3072"
    image   = "${get_parent_terragrunt_dir()}/../../packer/redhat/.cache/output/packer-redhat.qcow2"
    storage = "34359738368"  # 32GiB
    keys    = file("~/.ssh/id_rsa.pub")
  }
}
