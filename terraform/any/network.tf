
resource "libvirt_network" "any" {
    name      = var.any_id
    domain    = "local"
    addresses = [ var.network["subnet"] ]

    mode   = "nat"
    bridge = var.any_id

    dhcp { enabled = false }

    dns {
        enabled = true

        dynamic "hosts" {
            for_each = range(0, var.nodes["count"])
            content {
                hostname = "${var.any_id}n${hosts.value + 1}"
                ip       = cidrhost(var.network["subnet"], hosts.value + 10)
            }
        }
    }

    autostart = true
}

# vim:ts=4:sw=4:et:
