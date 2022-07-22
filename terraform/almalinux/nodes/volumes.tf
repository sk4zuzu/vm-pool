resource "libvirt_volume" "nodes_base" {
  count  = var.nodes.count > 0 ? 1 : 0
  name   = "${var.nodes.prefix}-base"
  source = var.nodes.image
  pool   = var.storage.pool
}

resource "libvirt_volume" "nodes" {
  count          = var.nodes.count
  name           = "${var.nodes.prefix}${count.index + 1}"
  size           = var.nodes.storage
  base_volume_id = libvirt_volume.nodes_base.*.id[0]
  pool           = var.storage.pool
}
