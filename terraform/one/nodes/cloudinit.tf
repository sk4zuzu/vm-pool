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
      dhcp4: false
      dhcp6: false
  bridges:
    eth1: # :D
      interfaces: [eth0]
      addresses:
        - ${cidrhost(var.network.subnet, count.index + var.nodes.offset)}/${split("/", var.network.subnet)[1]}
      dhcp4: false
      dhcp6: false
      macaddress: '${lower(format(var.network.macaddr, count.index + var.nodes.offset))}'
      nameservers:
        addresses:
          - 1.1.1.1
          - 8.8.8.8
        search:
          - ${var.network.domain}
      routes:
        - metric: 0
          to: 0.0.0.0/0
          via: ${cidrhost(var.network.subnet, 1)}
  EOF

  user_data = <<-EOF
  #cloud-config
  ssh_pwauth: false
  users:
    - name: ubuntu
      ssh_authorized_keys: ${jsonencode(var.nodes.keys)}
    - name: root
      ssh_authorized_keys: ${jsonencode(var.nodes.keys)}
  chpasswd:
    list:
      - ubuntu:asd
    expire: false
  growpart:
    mode: auto
    devices: [/]
  mounts:
    - [ 'asd', '/home/ubuntu/_git/', 'virtiofs', 'rw,relatime', '0', '0' ]
  write_files:
    - content: |
        [NetDev]
        Name=tap0
        Kind=tap
      path: /etc/systemd/network/tap0.netdev
    - content: |
        [Match]
        Name=tap0
        [Link]
        ActivationPolicy=always-up
        [Network]
        ConfigureWithoutCarrier=yes
      path: /etc/systemd/network/tap0.network
  runcmd:
    - networkctl reload
  EOF
}
