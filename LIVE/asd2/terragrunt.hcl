
include {
    path = "${find_in_parent_folders()}"
}

terraform {
    source = "../../terraform/asd/"
}

inputs = {
    shutdown = false

    asd_id = "x2"

    ssh_keys = [
        file("~/.ssh/id_rsa.pub"),
    ]

    pool_directory = "/stor/libvirt/vm_pool_x2"

    network = {
        subnet  = "10.20.3.0/24"
        macaddr = "52:54:20:03:00:%02x"
    }

    nodes1 = {
        count   = 3
        vcpu    = 2
        memory  = "2048"
        image   = "../../../../../packer/ubu/.cache/output/packer-ubu.qcow2"
        storage = "34359738368"  # 32GiB
    }

    nodes2 = {
        count   = 3
        vcpu    = 2
        memory  = "3072"
        image   = "../../../../../packer/ubu/.cache/output/packer-ubu.qcow2"
        storage = "17179869184"  # 16GiB
    }
}

# vim:ts=4:sw=4:et:
