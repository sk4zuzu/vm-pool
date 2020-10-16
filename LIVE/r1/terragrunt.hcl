include {
  path = "${find_in_parent_folders()}"
}

terraform {
  source = "../../terraform/redhat/"
}

inputs = {
  shutdown = false

  env_id = "r1"

  ssh_keys = [
    file("~/.ssh/id_rsa.pub"),
  ]

  pool_directory = "/stor/libvirt/vm_pool_r1"

  network = {
    subnet  = "10.40.2.0/24"
    macaddr = "52:54:40:02:00:%02x"
  }

  nodes1 = {
    count   = 3
    vcpu    = 2
    memory  = "2048"
    image   = "../../../../../packer/redhat/.cache/output/packer-redhat.qcow2"
    storage = "34359738368"  # 32GiB
  }

  nodes2 = {
    count   = 3
    vcpu    = 2
    memory  = "3072"
    image   = "../../../../../packer/redhat/.cache/output/packer-redhat.qcow2"
    storage = "17179869184"  # 16GiB
  }
}
