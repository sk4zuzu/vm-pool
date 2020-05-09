
resource "libvirt_domain" "nodes" {
    count = var._count

    name   = "${var.asd_id}${var._infix}${count.index + 1}"
    vcpu   = var.vcpu
    memory = var.memory

    cloudinit = libvirt_cloudinit_disk.nodes.*.id[count.index]

    network_interface {
        network_name   = var.network_name
        wait_for_lease = false
    }

    console {
        type        = "pty"
        target_port = "0"
        target_type = "serial"
    }

    console {
        type        = "pty"
        target_type = "virtio"
        target_port = "1"
    }

    disk {
        volume_id = libvirt_volume.nodes.*.id[count.index]
	}

    graphics {
        type           = "spice"
        listen_type    = "address"
        listen_address = "127.0.0.1"
        autoport       = true
    }

    autostart = !var.shutdown
}

# vim:ts=4:sw=4:et:
