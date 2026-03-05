locals {
  running = true

  env = "s1"

  network = {
    name    = local.env
    domain  = "opensuse.lh"
    macaddr = "52:54:02:00:60:%02x"
    subnet  = "10.2.60.0/24"
  }

  storage = {
    pool      = "vm_pool_${local.env}"
    directory = "/stor/libvirt/vm_pool_${local.env}"
  }

  mounts = [{
    target = "_shared"
    source = "/_shared/"
    path   = "/_shared/"
    ro     = false

  }]
  nodes1 = {
    count   = 1
    prefix  = "${local.env}a"
    offset  = 10
    vcpu    = 2
    memory  = "2048"
    image   = "${get_parent_terragrunt_dir()}/../../packer/opensuse/.cache/output/packer-opensuse.qcow2"
    storage = "34359738368"  # 32GiB
    keys    = file("~/.ssh/id_rsa.pub")
    disks   = []
    mounts  = local.mounts
  }

  nodes2 = {
    count   = 2
    prefix  = "${local.env}b"
    offset  = 20
    vcpu    = 2
    memory  = "3072"
    image   = "${get_parent_terragrunt_dir()}/../../packer/opensuse/.cache/output/packer-opensuse.qcow2"
    storage = "34359738368"  # 32GiB
    keys    = file("~/.ssh/id_rsa.pub")
    disks = [{
      name = "vdb"
      size = "68719476736"  # 64GiB
    },{
      name = "vdc"
      size = "68719476736"  # 64GiB
    }]
    mounts = local.mounts
  }
}
