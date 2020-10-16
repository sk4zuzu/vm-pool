resource "libvirt_network" "ubuntu" {
  name      = var.env_id
  domain    = "ubuntu.lh"
  addresses = [ var.network["subnet"] ]

  mode   = "nat"
  bridge = var.env_id

  dhcp { enabled = false }

  dns {
    enabled = true

    dynamic "hosts" {
      for_each = range(0, var.nodes1["count"])
      content {
        hostname = "${var.env_id}a${hosts.value + 1}"
        ip       = cidrhost(var.network["subnet"], hosts.value + 10)
      }
    }

    dynamic "hosts" {
      for_each = range(0, var.nodes2["count"])
      content {
        hostname = "${var.env_id}b${hosts.value + 1}"
        ip       = cidrhost(var.network["subnet"], hosts.value + 20)
      }
    }
  }

  autostart = true
}
