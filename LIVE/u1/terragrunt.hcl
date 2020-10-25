include {
  path = "${find_in_parent_folders()}"
}

terraform {
  source = "../../terraform/ubuntu/"
}

inputs = {
  shutdown = false

  env_id = "u1"

  ssh_keys = [
    file("~/.ssh/id_rsa.pub"),
  ]

  pool_directory = "/stor/libvirt/vm_pool_u1"

  network = {
    subnet  = "10.50.2.0/24"
    macaddr = "52:54:50:02:00:%02x"
  }

  nodes1 = {
    count   = 3
    vcpu    = 2
    memory  = "2048"
    image   = "../../../../../packer/ubuntu/.cache/output/packer-ubuntu.qcow2"
    storage = "34359738368"  # 32GiB
  }

  nodes2 = {
    count   = 3
    vcpu    = 2
    memory  = "3072"
    image   = "../../../../../packer/ubuntu/.cache/output/packer-ubuntu.qcow2"
    storage = "34359738368"  # 32GiB
  }
}
