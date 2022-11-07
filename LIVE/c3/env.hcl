locals {
  shutdown = false

  env = "c3"

  network = {
    name    = local.env
    domain  = "rocky.lh"
    macaddr = "52:54:02:00:32:%02x"
    subnet  = "10.2.32.0/24"
  }

  storage = {
    pool      = "vm_pool_${local.env}"
    directory = "/stor/libvirt/vm_pool_${local.env}"
  }

  nodes1 = {
    count    = 1
    prefix   = "${local.env}a"
    offset   = 10
    firmware = {
      file = "${get_parent_terragrunt_dir()}/../../bin/OVMF_CODE.fd"
      vars = "${get_parent_terragrunt_dir()}/../../bin/OVMF_VARS.fd"
    }
    vcpu     = 2
    memory   = "2048"
    image    = "${get_parent_terragrunt_dir()}/../../packer/rocky/.cache/output/packer-rocky.qcow2"
    storage  = "34359738368"  # 32GiB
    keys     = file("~/.ssh/id_rsa.pub")
  }

  nodes2 = {
    count    = 2
    prefix   = "${local.env}b"
    offset   = 20
    firmware = {
      file = "${get_parent_terragrunt_dir()}/../../bin/OVMF_CODE.fd"
      vars = "${get_parent_terragrunt_dir()}/../../bin/OVMF_VARS.fd"
    }
    vcpu     = 2
    memory   = "3072"
    image    = "${get_parent_terragrunt_dir()}/../../packer/rocky/.cache/output/packer-rocky.qcow2"
    storage  = "34359738368"  # 32GiB
    keys     = file("~/.ssh/id_rsa.pub")
  }
}
