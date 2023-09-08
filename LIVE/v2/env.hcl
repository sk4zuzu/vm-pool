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

  env = "v2"

  network = {
    name    = "br1"
    domain  = "libvirt.lh"
    macaddr = "52:54:17:22:01:%02x"
    subnet  = "172.20.100.0/24"
  }

  storage = {
    pool      = "vm_pool_${local.env}"
    directory = "/stor/libvirt/vm_pool_${local.env}"
  }

  nodes1 = {
    count   = 1
    prefix  = "${local.env}a"
    offset  = 30
    vcpu    = 2
    memory  = "1024"
    image   = "${get_parent_terragrunt_dir()}/../../packer/ubuntu/.cache/output/packer-ubuntu.qcow2"
    storage = "34359738368"  # 32GiB
    keys    = file("~/.ssh/id_rsa.pub")
  }
}
