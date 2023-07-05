locals {
  shutdown = true

  env = "n3"

  network = {
    name    = local.env
    domain  = "redhat.lh"
    macaddr = "52:54:02:00:52:%02x"
    subnet  = "10.2.52.0/24"
  }

  storage = {
    pool      = "vm_pool_${local.env}"
    directory = "/stor/libvirt/vm_pool_${local.env}"
  }

  mounts = [{
    target = "nfs0"
    source = "/stor/9p/${local.env}/_opt_nfs0/"
    path   = "/opt/nfs0/"
    ro     = false
  },{
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
    target = "git"
    source = "/home/asd/_git/"
    path   = "/home/cloud-user/_git/"
    ro     = false
  }]

  nodes1 = {
    count   = 3
    prefix  = "${local.env}a"
    offset  = 10
    vcpu    = 2
    memory  = "2048"
    image   = "${get_parent_terragrunt_dir()}/../../packer/redhat_9p/.cache/output/packer-redhat_9p.qcow2"
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
    image   = "${get_parent_terragrunt_dir()}/../../packer/redhat_9p/.cache/output/packer-redhat_9p.qcow2"
    storage = "94489280512"  # 88GiB
    keys    = file("~/.ssh/id_rsa.pub")
    mounts  = local.mounts
  }
}
