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
    - name: almalinux
      ssh_authorized_keys: ${jsonencode(var.nodes.keys)}
    - name: root
      ssh_authorized_keys: ${jsonencode(var.nodes.keys)}
  chpasswd:
    list:
      - almalinux:asd
      - root:asd
    expire: false
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
    - path: /etc/systemd/network/br0.netdev
      content: |
        [NetDev]
        Name=br0
        Kind=bridge
    - path: /etc/systemd/network/br0.network
      content: |
        [Match]
        Name=br0
        [Link]
        MACAddress=${lower(format(var.network.macaddr, count.index + var.nodes.offset))}
        ActivationPolicy=always-up
        [Network]
        DHCP=no
        Address=${cidrhost(var.network.subnet, count.index + var.nodes.offset)}/${split("/", var.network.subnet)[1]}
        Gateway=${cidrhost(var.network.subnet, 1)}
    - path: /etc/systemd/network/eth0.network
      content: |
        [Match]
        Name=eth0
        [Link]
        ActivationPolicy=always-up
        [Network]
        Bridge=br0

    - path: /etc/systemd/network/bond0.netdev
      content: |
        [NetDev]
        Name=bond0
        Kind=bond
    - path: /etc/systemd/network/bond0.31.netdev
      content: |
        [NetDev]
        Name=bond0.31
        Kind=vlan
        [VLAN]
        Id=31
    - path: /etc/systemd/network/bond0.31.network
      content: |
        [Match]
        Name=bond0.31
        [Link]
        MACAddress=${lower(format("52:54:56:58:31:%02x", count.index + var.nodes.offset))}
        ActivationPolicy=always-up
        [Network]
        DHCP=no
        Address=${cidrhost("192.168.31.0/24", count.index + var.nodes.offset)}/24
    - path: /etc/systemd/network/bond0.network
      content: |
        [Match]
        Name=bond0
        [Link]
        MACAddress=${lower(format("52:54:56:58:00:%02x", count.index + var.nodes.offset))}
        ActivationPolicy=always-up
        [Network]
        DHCP=no
        VLAN=bond0.31
    - path: /etc/systemd/network/eth1.network
      content: |
        [Match]
        Name=eth1
        [Link]
        ActivationPolicy=always-up
        [Network]
        Bond=bond0
    - path: /etc/systemd/network/eth2.network
      content: |
        [Match]
        Name=eth2
        [Link]
        ActivationPolicy=always-up
        [Network]
        Bond=bond0

    - path: /etc/resolv.conf
      content: |
        nameserver ${cidrhost(var.network.subnet, 1)}
        search ${var.network.domain}
    - path: /etc/sysctl.d/98-ip-forward.conf
      content: |
        net.ipv4.ip_forward = 1
  bootcmd:
    - systemctl disable NetworkManager --now
  runcmd:
    - sysctl -p /etc/sysctl.d/98-ip-forward.conf
    - systemctl reload systemd-networkd
  EOF
}
