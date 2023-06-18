locals {
  shutdown = false

  env = "k2"

  network = {
    name    = local.env
    domain  = "kubelo.lh"
    macaddr = "52:54:02:00:41:%02x"
    subnet  = "10.2.41.0/24"
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
    memory  = "3072"
    image   = "${get_parent_terragrunt_dir()}/../../packer/kub3lo/rke2/.cache/output/packer-kub3lo.qcow2"
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
    image   = "${get_parent_terragrunt_dir()}/../../packer/kub3lo/rke2/.cache/output/packer-kub3lo.qcow2"
    storage = "34359738368"  # 32GiB
    keys    = file("~/.ssh/id_rsa.pub")
    disks   = []
    mounts  = []
  }
}
