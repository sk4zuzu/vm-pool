
resource "libvirt_cloudinit_disk" "nodes" {
    count = var._count

    name = "${var.any_id}n${count.index + 1}.iso"
    pool = var.storage_pool

    meta_data = <<-EOF
    instance-id: '${var.any_id}n${count.index + 1}'
    local-hostname: '${var.any_id}n${count.index + 1}'
    EOF

    network_config = <<-EOF
    version: 2
    ethernets:
      ens3:
        addresses:
          - '${cidrhost(var.subnet, count.index + 10)}/${split("/", var.subnet)[1]}'
        dhcp4: false
        dhcp6: false
        gateway4: '${cidrhost(var.subnet, 1)}'
        macaddress: '${format(var.macaddr, count.index + 10)}'
        nameservers:
          addresses:
            - '${cidrhost(var.subnet, 1)}'
          search:
            - 'local'
    EOF

    user_data = <<-EOF
    #cloud-config
    ssh_pwauth: false
    users:
      - name: ubuntu
        ssh_authorized_keys: ${jsonencode(var.ssh_keys)}
      - name: root
        ssh_authorized_keys: ${jsonencode(var.ssh_keys)}
    chpasswd:
      list:
        - 'ubuntu:#ubuntu@!?'
      expire: false
    growpart:
      mode: auto
      devices: ['/']
    write_files:
      - content: |
          net.ipv4.ip_forward = 1
        path: '/etc/sysctl.d/98-ip-forward.conf'
    runcmd:
      - ['sysctl', '-p', '/etc/sysctl.d/98-ip-forward.conf']
    EOF
}

# vim:ts=4:sw=4:et:
