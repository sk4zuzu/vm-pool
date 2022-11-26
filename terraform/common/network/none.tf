resource "libvirt_network" "none" {
  for_each = toset([
    "${var.env}none1",
    "${var.env}none2",
  ])

  name = each.value

  mode   = "none"
  bridge = each.value

  dhcp { enabled = false }
  dns { enabled = false }

  autostart = true
}
