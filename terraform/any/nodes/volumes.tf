
resource "libvirt_volume" "nodes_base" {
    count = var._count > 0 ? 1 : 0

    name   = "${var.any_id}-base"
    source = var.image
    pool   = var.storage_pool
}

resource "libvirt_volume" "nodes" {
    count = var._count

    name           = "${var.any_id}n${count.index + 1}"
    size           = var.storage
    base_volume_id = libvirt_volume.nodes_base.*.id[0]
    pool           = var.storage_pool
}

# vim:ts=4:sw=4:et:
