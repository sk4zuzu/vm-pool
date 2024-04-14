resource "libvirt_cloudinit_disk" "nodes" {
  count = var.nodes.count
  name  = "${var.nodes.prefix}${count.index + 1}.iso"
  pool  = var.storage.pool

  meta_data = <<-EOF
  instance-id: ${var.nodes.prefix}${count.index + 1}
  local-hostname: ${var.nodes.prefix}${count.index + 1}
  EOF

  #meta_data = <<-EOF
  #instance-id: ${var.nodes.prefix}${count.index + 1}
  #local-hostname: ${var.nodes.prefix}${count.index + 1}
  #network-interfaces: |
  #  iface eth0 inet static
  #  hwaddress ether ${lower(format(var.network.macaddr, count.index + var.nodes.offset))}
  #  address ${cidrhost(var.network.subnet, count.index + var.nodes.offset)}
  #  netmask ${cidrnetmask(var.network.subnet)}
  #  gateway ${cidrhost(var.network.subnet, 1)}
  #EOF

  network_config = <<-EOF
  version: 2
  ethernets:
    eth0:
      dhcp4: false
      dhcp6: false
  bridges:
    br0:
      interfaces: [eth0]
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
      parameters: {} # FIX
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
      - centos:asd
    expire: false
  growpart:
    mode: auto
    devices: [/]
  write_files:
    - content: |
        net.ipv4.ip_forward = 1
      path: /etc/sysctl.d/98-ip-forward.conf
  runcmd:
    - sysctl -p /etc/sysctl.d/98-ip-forward.conf
  EOF
}
