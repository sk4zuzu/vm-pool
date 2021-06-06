resource "libvirt_network" "self" {
  name      = var.network.name
  domain    = var.network.domain
  addresses = [ var.network.subnet ]

  mode   = "nat"
  bridge = var.network.name

  dhcp { enabled = false }

  dns {
    enabled = true

    dynamic "hosts" {
      for_each = range(0, var.nodes1.count)
      content {
        hostname = "${var.nodes1.prefix}${hosts.value + 1}"
        ip       = cidrhost(var.network.subnet, hosts.value + var.nodes1.offset)
      }
    }

    dynamic "hosts" {
      for_each = range(0, var.nodes2.count)
      content {
        hostname = "${var.nodes2.prefix}${hosts.value + 1}"
        ip       = cidrhost(var.network.subnet, hosts.value + var.nodes2.offset)
      }
    }
  }

  autostart = true
}
