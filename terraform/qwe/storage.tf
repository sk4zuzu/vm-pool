
resource "libvirt_pool" "qwe" {
    name = "vm_pool_${var.qwe_id}"
    type = "dir"
    path = var.pool_directory
}

# vim:ts=4:sw=4:et:
