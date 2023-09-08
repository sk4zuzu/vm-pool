resource "libvirt_network" "self" {
  name = var.network.name

  mode   = "bridge"
  bridge = var.network.name

  dhcp { enabled = false }
  dns { enabled = false }

  autostart = true
}
