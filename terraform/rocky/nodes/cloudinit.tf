resource "libvirt_cloudinit_disk" "nodes" {
  count = var.nodes.count
  name  = "${var.nodes.prefix}${count.index + 1}.iso"
  pool  = var.storage.pool

  meta_data = <<-EOF
  instance-id: ${var.nodes.prefix}${count.index + 1}
  local-hostname: ${var.nodes.prefix}${count.index + 1}
  EOF

  user_data = <<-EOF
  #cloud-config
  ssh_pwauth: false
  users:
    - name: rocky
      ssh_authorized_keys: ${jsonencode(var.nodes.keys)}
    - name: root
      ssh_authorized_keys: ${jsonencode(var.nodes.keys)}
  chpasswd:
    list:
      - rocky:asd
    expire: false
  growpart:
    mode: auto
    devices: [/]
  write_files:
    - content: |
        [NetDev]
        Kind=bridge
        Name=br0
      path: /etc/systemd/network/br0.netdev
    - content: |
        [Match]
        Name=br0
        [Link]
        MACAddress=${lower(format(var.network.macaddr, count.index + var.nodes.offset))}
        ActivationPolicy=always-up
        [Network]
        Address=${cidrhost(var.network.subnet, count.index + var.nodes.offset)}/${split("/", var.network.subnet)[1]}
        Gateway=${cidrhost(var.network.subnet, 1)}
      path: /etc/systemd/network/br0.network
    - content: |
        [Match]
        Name=eth0
        [Link]
        ActivationPolicy=always-up
        [Network]
        Bridge=br0
      path: /etc/systemd/network/eth0.network
    - content: |
        nameserver ${cidrhost(var.network.subnet, 1)}
        search ${var.network.domain}
      path: /etc/resolv.conf
    - content: |
        net.ipv4.ip_forward = 1
      path: /etc/sysctl.d/98-ip-forward.conf
  bootcmd:
    - systemctl disable NetworkManager --now
  runcmd:
    - sysctl -p /etc/sysctl.d/98-ip-forward.conf
    - systemctl reload systemd-networkd
  EOF
}
