locals {
  shutdown = false

  env = "n2"

  network = {
    name    = local.env
    domain  = "almalinux.lh"
    macaddr = "52:54:02:00:51:%02x"
    subnet  = "10.2.51.0/24"
  }

  storage = {
    pool      = "vm_pool_${local.env}"
    directory = "/stor/libvirt/vm_pool_${local.env}"
  }

  mounts = [{
    target = "nfs1"
    source = "/stor/9p/${local.env}/_opt_nfs1/"
    path   = "/opt/nfs1/"
    ro     = false
  },{
    target = "nfs2"
    source = "/stor/9p/${local.env}/_opt_nfs2/"
    path   = "/opt/nfs2/"
    ro     = false
  },{
    target = "nfs3"
    source = "/stor/9p/${local.env}/_opt_nfs3/"
    path   = "/opt/nfs3/"
    ro     = false
  },{
    target = "nfs4"
    source = "/stor/9p/${local.env}/_opt_nfs4/"
    path   = "/opt/nfs4/"
    ro     = false
  }]

  nodes1 = {
    count   = 3
    prefix  = "${local.env}a"
    offset  = 10
    vcpu    = 2
    memory  = "2048"
    image   = "${get_parent_terragrunt_dir()}/../../packer/almalinux_9p/.cache/output/packer-almalinux_9p.qcow2"
    storage = "34359738368"  # 32GiB
    keys    = file("~/.ssh/id_rsa.pub")
    mounts  = local.mounts
  }

  nodes2 = {
    count   = 4
    prefix  = "${local.env}b"
    offset  = 20
    vcpu    = 2
    memory  = "3072"
    image   = "${get_parent_terragrunt_dir()}/../../packer/almalinux_9p/.cache/output/packer-almalinux_9p.qcow2"
    storage = "34359738368"  # 32GiB
    keys    = file("~/.ssh/id_rsa.pub")
    mounts  = local.mounts
  }
}
