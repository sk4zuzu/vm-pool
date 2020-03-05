
include {
    path = "${find_in_parent_folders()}"
}

terraform {
    source = "../../terraform/any/"
}

inputs = {
    any_id = "a1"

    ssh_keys = [
        file("~/.ssh/id_ed25519.pub"),
    ]

    pool_directory = "/stor/libvirt/vm_pool"

    network = {
        subnet  = "10.20.1.0/24"
        macaddr = "52:54:20:01:00:%02x"
    }

    nodes = {
        count   = 3
        vcpu    = 2
        memory  = "2048"
        image   = "../../../../../packer/any/.cache/output/packer-any.qcow2"
        storage = "17179869184"  # 16GiB
    }
}

# vim:ts=4:sw=4:et:
