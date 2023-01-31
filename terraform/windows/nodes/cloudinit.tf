resource "libvirt_cloudinit_disk" "nodes" {
  count = var.nodes.count
  name  = "${var.nodes.prefix}${count.index + 1}.iso"
  pool  = var.storage.pool

  meta_data = <<-EOF
  instance-id: ${var.nodes.prefix}${count.index + 1}
  local-hostname: ${var.nodes.prefix}${count.index + 1}
  network-interfaces: |
    iface eth0 inet static
    address ${cidrhost(var.network.subnet, count.index + var.nodes.offset)}
    netmask ${cidrnetmask(var.network.subnet)}
    gateway ${cidrhost(var.network.subnet, 1)}
  EOF

  user_data = <<-EOF
  #cloud-config
  runcmd:
    - powershell.exe -Command Set-NetAdapter "eth0" -MacAddress "${lower(format(var.network.macaddr, count.index + var.nodes.offset))}" -Confirm:$false
  EOF
}
