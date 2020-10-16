resource "libvirt_pool" "redhat" {
  name = "vm_pool_${var.env_id}"
  type = "dir"
  path = var.pool_directory
}
