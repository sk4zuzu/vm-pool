
resource "libvirt_network" "zxc" {
    name      = var.zxc_id
    domain    = "zxc.lh"
    addresses = [ var.network["subnet"] ]

    mode   = "nat"
    bridge = var.zxc_id

    dhcp { enabled = false }

    dns {
        enabled = true

        dynamic "hosts" {
            for_each = range(0, var.nodes1["count"])
            content {
                hostname = "${var.zxc_id}a${hosts.value + 1}"
                ip       = cidrhost(var.network["subnet"], hosts.value + 10)
            }
        }

        dynamic "hosts" {
            for_each = range(0, var.nodes2["count"])
            content {
                hostname = "${var.zxc_id}b${hosts.value + 1}"
                ip       = cidrhost(var.network["subnet"], hosts.value + 20)
            }
        }
    }

    autostart = true
}

# vim:ts=4:sw=4:et:
