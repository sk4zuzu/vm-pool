resource "libvirt_pool" "self" {
  name = var.storage.pool
  type = "dir"

  target = {
    path = var.storage.directory
  }
}
