resource "libvirt_volume" "nodes_base" {
  name = "${var.nodes.prefix}-base"
  pool = var.storage.pool

  target = {
    format = { type = "qcow2" }
  }

  create = {
    content = { url = var.nodes.image }
  }
}

resource "libvirt_volume" "nodes_root" {
  count = var.nodes.count

  name = "${var.nodes.prefix}${count.index + 1}"
  pool = var.storage.pool

  capacity      = var.nodes.storage
  capacity_unit = "bytes"

  target = {
    format = { type = "qcow2" }
  }

  backing_store = {
    format = { type = "qcow2" }
    path   = libvirt_volume.nodes_base.path
  }
}

resource "libvirt_volume" "nodes_init" {
  count = var.nodes.count

  name = "${var.nodes.prefix}${count.index + 1}.iso"
  pool = var.storage.pool

  target = {
    format = { type = "iso" }
  }

  create = {
    content = {
      url = libvirt_cloudinit_disk.nodes[count.index].path
    }
  }
}
