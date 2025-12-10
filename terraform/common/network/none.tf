resource "libvirt_network" "none" {
  for_each = toset(["${var.env}none1", "${var.env}none2"])

  name = each.value

  bridge = {
    name = each.value
    stp  = "on"
  }

  autostart = true
}
