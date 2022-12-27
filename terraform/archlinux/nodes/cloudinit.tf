resource "libvirt_cloudinit_disk" "nodes" {
  count = var.nodes.count
  name  = "${var.nodes.prefix}${count.index + 1}.iso"
  pool  = var.storage.pool

  meta_data = <<-EOF
  instance-id: ${var.nodes.prefix}${count.index + 1}
  local-hostname: ${var.nodes.prefix}${count.index + 1}
  EOF

  network_config = <<-EOF
  version: 2
  ethernets:
    eth0:
      macaddress: '${lower(format(var.network.macaddr, count.index + var.nodes.offset))}'
      addresses:
        - ${cidrhost(var.network.subnet, count.index + var.nodes.offset)}/${split("/", var.network.subnet)[1]}
      dhcp4: false
      dhcp6: false
      gateway4: ${cidrhost(var.network.subnet, 1)}
      nameservers:
        addresses:
          - ${cidrhost(var.network.subnet, 1)}
        search:
          - ${var.network.domain}
  EOF

  user_data = <<-EOF
  #cloud-config
  ssh_pwauth: false
  users:
    - name: arch
      ssh_authorized_keys: ${jsonencode(var.nodes.keys)}
    - name: root
      ssh_authorized_keys: ${jsonencode(var.nodes.keys)}
  chpasswd:
    list:
      - arch:asd
      - root:asd
    expire: false
  growpart:
    mode: auto
    devices: [/]
  write_files:
    - path: /etc/sysctl.d/98-ip-forward.conf
      content: |
        net.ipv4.ip_forward = 1
  runcmd:
    - sysctl -p /etc/sysctl.d/98-ip-forward.conf
  EOF
}
