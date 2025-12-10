locals {
  pubkeys = flatten([[
    for v in split("\n", var.nodes.keys) : trimspace(v) if trimspace(v) != ""
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
    eth0:
      dhcp4: false
      dhcp6: false
    eth1:
      dhcp4: false
      dhcp6: false
    eth2:
      dhcp4: false
      dhcp6: false
  bridges:
    br0:
      interfaces: [eth0]
      dhcp4: false
      dhcp6: false
      macaddress: '${lower(format(var.network.macaddr, count.index + var.nodes.offset))}'
      addresses:
        - ${cidrhost(var.network.subnet, count.index + var.nodes.offset)}/${split("/", var.network.subnet)[1]}
      routes:
        - metric: 0
          to: 0.0.0.0/0
          via: ${cidrhost(var.network.subnet, 1)}
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
    - name: cloud-user
      lock_passwd: false
      ssh_authorized_keys: ${jsonencode(local.pubkeys)}
    - name: root
      lock_passwd: false
      ssh_authorized_keys: ${jsonencode(local.pubkeys)}
  growpart:
    mode: auto
    devices: [/]
  %{if length(var.nodes.mounts) > 0}
  mounts:
  %{endif}
  %{for mount in var.nodes.mounts}
    - [ ${mount.target}, ${mount.path}, '9p', 'trans=virtio,version=9p2000.L,${mount.ro ? "r" : "rw"}', '0', '0' ]
  %{endfor}
  write_files:
    - path: /etc/sysctl.d/98-ip-forward.conf
      content: |
        net.ipv4.ip_forward = 1
  runcmd:
    - sysctl -p /etc/sysctl.d/98-ip-forward.conf
  EOF
}
