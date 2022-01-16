resource "libvirt_cloudinit_disk" "nodes" {
  count = var.nodes.count
  name  = "${var.nodes.prefix}${count.index + 1}.iso"
  pool  = var.storage.pool

  meta_data = <<-EOF
  instance-id: ${var.nodes.prefix}${count.index + 1}
  local-hostname: ${var.nodes.prefix}${count.index + 1}
  network-interfaces: |
    iface eth0 inet static
    hwaddress ether ${format(var.network.macaddr, count.index + var.nodes.offset)}
    address ${cidrhost(var.network.subnet, count.index + var.nodes.offset)}
    netmask ${cidrnetmask(var.network.subnet)}
    gateway ${cidrhost(var.network.subnet, 1)}
  EOF

  user_data = <<-EOF
  #cloud-config
  ssh_pwauth: false
  users:
    - name: centos
      ssh_authorized_keys: ${jsonencode(var.nodes.keys)}
    - name: root
      ssh_authorized_keys: ${jsonencode(var.nodes.keys)}
  chpasswd:
    list:
      - 'centos:#centos@!?'
    expire: false
  growpart:
    mode: auto
    devices: [/]
  write_files:
    - content: |
        nameserver ${cidrhost(var.network.subnet, 1)}
        search ${var.network.domain}
      path: /etc/resolv.conf
    - content: |
        net.ipv4.ip_forward = 1
      path: /etc/sysctl.d/98-ip-forward.conf
  bootcmd:
    - sed -i 's|^HWADDR=|MACADDR=|' /etc/sysconfig/network-scripts/ifcfg-eth0
    - systemctl disable NetworkManager && systemctl stop NetworkManager
    - systemctl enable network && systemctl start network
    - ifdown eth0 && ifup eth0
  runcmd:
    - sysctl -p /etc/sysctl.d/98-ip-forward.conf
  EOF
}
