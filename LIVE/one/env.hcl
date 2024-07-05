locals {
  shutdown = false

  env = "one"

  network = {
    name    = "br0"
    domain  = "ubuntu.lh"
    macaddr = "52:54:02:00:11:%02x"
    subnet  = "10.2.11.0/24"
  }

  storage = {
    pool      = "vm_pool_${local.env}"
    directory = "/stor/libvirt/vm_pool_${local.env}"
  }

  nodes1 = {
    count   = 1
    prefix  = local.env
    offset  = 10
    vcpu    = 4
    memory  = "6144"
    image   = "${get_parent_terragrunt_dir()}/../../packer/one/.cache/output/packer-one.qcow2"
    storage = "94489280512"  # 88GiB
    keys    = file("~/.ssh/id_rsa.pub")
  }
}
