
resource "libvirt_pool" "zxc" {
    name = "vm_pool_${var.zxc_id}"
    type = "dir"
    path = var.pool_directory
}

# vim:ts=4:sw=4:et:
