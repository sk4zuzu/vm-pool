
resource "libvirt_pool" "asd" {
    name = "vm_pool_${var.asd_id}"
    type = "dir"
    path = var.pool_directory
}

# vim:ts=4:sw=4:et:
