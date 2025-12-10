locals {
  running = true

  env = "u1"

  network = {
    name    = local.env
    domain  = "ubuntu.lh"
    macaddr = "52:54:02:00:80:%02x"
    subnet  = "10.2.80.0/24"
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
    image   = "${get_parent_terragrunt_dir()}/../../packer/ubuntu/.cache/output/packer-ubuntu.qcow2"
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
    memory  = "2048"
    image   = "${get_parent_terragrunt_dir()}/../../packer/ubuntu/.cache/output/packer-ubuntu.qcow2"
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
