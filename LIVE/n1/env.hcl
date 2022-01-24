locals {
  shutdown = false

  env = "n1"

  network = {
    name    = local.env
    domain  = "nebula.lh"
    macaddr = "52:54:50:02:00:%02x"
    subnet  = "10.50.2.0/24"
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
    image   = "${get_parent_terragrunt_dir()}/../../packer/nebula/.cache/output/packer-nebula.qcow2"
    storage = "94489280512"  # 88GiB
    keys    = file("~/.ssh/id_rsa.pub")
  }

  nodes2 = {
    count   = 1
    prefix  = "${local.env}b"
    offset  = 20
    vcpu    = 16
    memory  = "16384"
    image   = "${get_parent_terragrunt_dir()}/../../packer/nebula/.cache/output/packer-nebula.qcow2"
    storage = "94489280512"  # 88GiB
    keys    = file("~/.ssh/id_rsa.pub")
  }
}
