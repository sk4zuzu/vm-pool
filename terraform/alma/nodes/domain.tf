resource "libvirt_domain" "nodes" {
  count  = var.nodes.count
  name   = "${var.nodes.prefix}${count.index + 1}"
  vcpu   = var.nodes.vcpu
  memory = var.nodes.memory

  cloudinit = libvirt_cloudinit_disk.nodes.*.id[count.index]

  cpu {
    mode = "host-passthrough"
  }

  network_interface {
    network_name   = var.network.name
    wait_for_lease = false
  }
  dynamic "network_interface" {
    for_each = toset([
      "${var.env}none1",
      "${var.env}none2",
    ])
    content {
      network_name   = network_interface.value
      wait_for_lease = false
    }
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
    type           = "vnc"
    listen_type    = "address"
    listen_address = "127.0.0.1"
    autoport       = true
  }

  autostart = !var.shutdown
}
