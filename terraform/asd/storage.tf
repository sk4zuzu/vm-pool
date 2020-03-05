
resource "libvirt_pool" "asd" {
    name = "vm_pool"
    type = "dir"
    path = var.pool_directory
}

# vim:ts=4:sw=4:et:
