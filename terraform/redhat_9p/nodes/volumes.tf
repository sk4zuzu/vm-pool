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

locals {
  disks = zipmap(
    flatten([
      for index in range(var.nodes.count) : [
        for disk in var.nodes.disks : "${var.nodes.prefix}${index + 1}-${disk.name}"
      ]
    ]),
    flatten([
      for index in range(var.nodes.count) : var.nodes.disks
    ]),
  )
}

resource "libvirt_volume" "nodes_extra" {
  for_each = local.disks
  name     = each.key
  size     = each.value.size
  pool     = var.storage.pool
}
