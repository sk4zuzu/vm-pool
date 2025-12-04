locals {
  shutdown = false

  env = "c1"

  network = {
    name    = local.env
    domain  = "centos.lh"
    macaddr = "52:54:02:00:30:%02x"
    subnet  = "10.2.30.0/24"
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
    image   = "${get_parent_terragrunt_dir()}/../../packer/centos/.cache/output/packer-centos.qcow2"
    storage = "34359738368"  # 32GiB
    keys    = file("~/.ssh/id_rsa.pub")
    disks   = []
  }

  nodes2 = {
    count   = 0
    prefix  = "${local.env}b"
    offset  = 20
    vcpu    = 2
    memory  = "3072"
    image   = "${get_parent_terragrunt_dir()}/../../packer/centos/.cache/output/packer-centos.qcow2"
    storage = "34359738368"  # 32GiB
    keys    = file("~/.ssh/id_rsa.pub")
    disks   = []
  }
}
