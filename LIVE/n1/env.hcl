locals {
  shutdown = false

  env = "n1"

  network = {
    name    = local.env
    domain  = "ubuntu.lh"
    macaddr = "52:54:02:00:50:%02x"
    subnet  = "10.2.50.0/24"
  }

  storage = {
    pool      = "vm_pool_${local.env}"
    directory = "/stor/libvirt/vm_pool_${local.env}"
  }

  mounts = [{
    target = "datastores"
    source = "/stor/9p/${local.env}/_var_lib_one_datastores/"
    path   = "/var/lib/one/datastores/"
    ro     = false
  },{
    target = "git"
    source = "/home/asd/_git/"
    path   = "/home/ubuntu/_git/"
    ro     = false
  }]

  nodes1 = {
    count   = 3
    prefix  = "${local.env}a"
    offset  = 10
    vcpu    = 2
    memory  = "2048"
    image   = "${get_parent_terragrunt_dir()}/../../packer/nebula/.cache/output/packer-nebula.qcow2"
    storage = "94489280512"  # 88GiB
    keys    = file("~/.ssh/id_rsa.pub")
    mounts  = local.mounts
  }

  nodes2 = {
    count   = 2
    prefix  = "${local.env}b"
    offset  = 20
    vcpu    = 4
    memory  = "3072"
    image   = "${get_parent_terragrunt_dir()}/../../packer/nebula/.cache/output/packer-nebula.qcow2"
    storage = "94489280512"  # 88GiB
    keys    = file("~/.ssh/id_rsa.pub")
    mounts  = local.mounts
  }
}
