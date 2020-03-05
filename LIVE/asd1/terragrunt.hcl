
include {
    path = "${find_in_parent_folders()}"
}

terraform {
    source = "../../terraform/asd/"
}

inputs = {
    asd_id = "x1"

    ssh_keys = [
        file("~/.ssh/id_ed25519.pub"),
    ]

    pool_directory = "/stor/libvirt/vm_pool"

    network = {
        subnet  = "10.20.2.0/24"
        macaddr = "52:54:20:02:00:%02x"
    }

    nodes1 = {
        count   = 3
        vcpu    = 2
        memory  = "2400"
        image   = "../../../../../packer/any/.cache/output/packer-any.qcow2"
        storage = "34359738368"  # 32GiB
    }

    nodes2 = {
        count   = 1
        vcpu    = 2
        memory  = "1200"
        image   = "../../../../../packer/any/.cache/output/packer-any.qcow2"
        storage = "17179869184"  # 16GiB
    }
}

# vim:ts=4:sw=4:et:
