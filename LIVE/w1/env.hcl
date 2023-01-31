locals {
  shutdown = false

  env = "w1"

  network = {
    name    = local.env
    domain  = "windows.lh"
    macaddr = "52:54:02:01:30:%02x"
    subnet  = "10.2.130.0/24"
  }

  storage = {
    pool      = "vm_pool_${local.env}"
    directory = "/stor/libvirt/vm_pool_${local.env}"
  }

  nodes1 = {
    count   = 1
    prefix  = "${local.env}a"
    offset  = 10
    firmware = {
      file = "${get_parent_terragrunt_dir()}/../../bin/OVMF_CODE.fd"
      vars = "${get_parent_terragrunt_dir()}/../../bin/OVMF_VARS.fd"
    }
    vcpu    = 2
    memory  = "3072"
    image   = "${get_parent_terragrunt_dir()}/../../packer/windows/.cache/output/packer-windows.qcow2"
    storage = "34359738368"  # 32GiB
  }

  nodes2 = {
    count   = 0
    prefix  = "${local.env}b"
    offset  = 20
    firmware = {
      file = "${get_parent_terragrunt_dir()}/../../bin/OVMF_CODE.fd"
      vars = "${get_parent_terragrunt_dir()}/../../bin/OVMF_VARS.fd"
    }
    vcpu    = 2
    memory  = "3072"
    image   = "${get_parent_terragrunt_dir()}/../../packer/windows/.cache/output/packer-windows.qcow2"
    storage = "34359738368"  # 32GiB
  }
}
