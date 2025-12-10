locals {
  pubkeys = flatten([[
    for k in split("\n", var.nodes.keys) : trimspace(k) if trimspace(k) != ""
  ]])
}

resource "libvirt_cloudinit_disk" "nodes" {
  count = var.nodes.count
  name  = "${var.nodes.prefix}${count.index + 1}.iso"

  meta_data = <<-EOF
  instance-id: ${var.nodes.prefix}${count.index + 1}
  local-hostname: ${var.nodes.prefix}${count.index + 1}
  EOF

  network_config = <<-EOF
  version: 2
  ethernets:
    vioif0:
      addresses:
        - ${cidrhost(var.network.subnet, count.index + var.nodes.offset)}/${split("/", var.network.subnet)[1]}
      dhcp4: false
      dhcp6: false
      gateway4: ${cidrhost(var.network.subnet, 1)}
      macaddress: '${lower(format(var.network.macaddr, count.index + var.nodes.offset))}'
      nameservers:
        addresses:
          - ${cidrhost(var.network.subnet, 1)}
        search:
          - ${var.network.domain}
  EOF

  user_data = <<-EOF
  #cloud-config
  users:
    - name: netbsd
      lock_passwd: false
      ssh_authorized_keys: ${jsonencode(local.pubkeys)}
      sudo: ALL=(ALL) NOPASSWD:ALL
    - name: root
      lock_passwd: false
      ssh_authorized_keys: ${jsonencode(local.pubkeys)}
  write_files:
    - path: /etc/sysctl.conf
      content: |
        net.inet.ip.forwarding=1
      append: true
  runcmd:
    # normally '-w' is ignored in other unix-like
    - sysctl -w net.inet.ip.forwarding=1
  EOF
}
