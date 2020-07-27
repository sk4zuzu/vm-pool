
resource "libvirt_cloudinit_disk" "nodes" {
    count = var._count

    name = "${var.qwe_id}${var._infix}${count.index + 1}.iso"
    pool = var.storage_pool

    meta_data = <<-EOF
    instance-id: '${var.qwe_id}${var._infix}${count.index + 1}'
    local-hostname: '${var.qwe_id}${var._infix}${count.index + 1}'
    network-interfaces: |
      iface eth0 inet static
      hwaddress ether ${format(var.macaddr, count.index + var._ipgap)}
      address ${cidrhost(var.subnet, count.index + var._ipgap)}
      netmask ${cidrnetmask(var.subnet)}
      gateway ${cidrhost(var.subnet, 1)}
    EOF

    user_data = <<-EOF
    #cloud-config
    ssh_pwauth: false
    users:
      - name: 'centos'
        ssh_authorized_keys: ${jsonencode(var.ssh_keys)}
      - name: 'root'
        ssh_authorized_keys: ${jsonencode(var.ssh_keys)}
    chpasswd:
      list:
        - 'centos:#centos@!?'
      expire: false
    growpart:
      mode: auto
      devices: ['/']
    write_files:
      - content: |
          nameserver ${cidrhost(var.subnet, 1)}
          search qwe.lh
        path: '/etc/resolv.conf'
      - content: |
          net.ipv4.ip_forward = 1
        path: '/etc/sysctl.d/98-ip-forward.conf'
    bootcmd:
      - sed -i 's|^HWADDR=|MACADDR=|' '/etc/sysconfig/network-scripts/ifcfg-eth0'
      - systemctl disable NetworkManager && systemctl stop NetworkManager
      - systemctl enable network && systemctl start network
      - ifdown eth0 && ifup eth0
    runcmd:
      - sysctl -p '/etc/sysctl.d/98-ip-forward.conf'
    EOF
}

# vim:ts=4:sw=4:et:
