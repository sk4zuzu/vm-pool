locals {
  shutdown = false

  env = "f1"

  network = {
    name    = local.env
    domain  = "fedora.lh"
    macaddr = "52:54:02:90:00:%02x"
    subnet  = "10.2.90.0/24"
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
    image   = "${get_parent_terragrunt_dir()}/../../packer/fedora/.cache/output/packer-fedora.qcow2"
    storage = "34359738368"  # 32GiB
    keys    = file("~/.ssh/id_rsa.pub")
    disks   = []
    mounts  = []
  }

  nodes2 = {
    count   = 3
    prefix  = "${local.env}b"
    offset  = 20
    vcpu    = 2
    memory  = "3072"
    image   = "${get_parent_terragrunt_dir()}/../../packer/fedora/.cache/output/packer-fedora.qcow2"
    storage = "34359738368"  # 32GiB
    keys    = file("~/.ssh/id_rsa.pub")
    disks = [{
      name = "vdb"
      size = "68719476736"  # 64GiB
    },{
      name = "vdc"
      size = "68719476736"  # 64GiB
    }]
    mounts = []
  }
}
