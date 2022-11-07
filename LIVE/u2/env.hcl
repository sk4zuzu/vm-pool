generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
provider "libvirt" {
  uri = "qemu+tcp://10.2.51.10/system"
}
EOF
}

locals {
  shutdown = false

  env = "u2"

  network = {
    name    = local.env
    domain  = "ubuntu.lh"
    macaddr = "52:54:02:00:81:%02x"
    subnet  = "10.2.81.0/24"
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
    image   = "${get_parent_terragrunt_dir()}/../../packer/ubuntu/.cache/output/packer-ubuntu.qcow2"
    storage = "12884901888"  # 12GiB
    keys    = file("~/.ssh/id_rsa.pub")
    disks   = []
    mounts  = []
  }

  nodes2 = {
    count   = 0
    prefix  = "${local.env}b"
    offset  = 10
    vcpu    = 2
    memory  = "2048"
    image   = "${get_parent_terragrunt_dir()}/../../packer/ubuntu/.cache/output/packer-ubuntu.qcow2"
    storage = "12884901888"  # 12GiB
    keys    = file("~/.ssh/id_rsa.pub")
    disks   = []
    mounts  = []
  }
}
