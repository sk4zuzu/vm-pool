resource "libvirt_cloudinit_disk" "nodes" {
  count = var.nodes.count
  name  = "${var.nodes.prefix}${count.index + 1}.iso"

  meta_data = jsonencode({
    hostname = "${var.nodes.prefix}${count.index + 1}"
    keys     = var.nodes.keys
  })

  user_data = <<-USERDATA
  #!/usr/bin/env bash
  set -xeo pipefail

  install -o 0 -g 0 -m u=rwx,go=rx /dev/fd/0 /etc/rc.local <<'EOF'
  #!/usr/bin/env bash
  set -xeo pipefail

  ip link set dev 'eth0' address '${lower(format(var.network.macaddr, count.index + var.nodes.offset))}'
  ip link set dev 'eth0' up

  ip addr add '${cidrhost(var.network.subnet, count.index + var.nodes.offset)}/${split("/", var.network.subnet)[1]}' dev 'eth0'
  ip route add default via '${cidrhost(var.network.subnet, 1)}'
  EOF

  install -o 0 -g 0 -m u=rw,go=r /dev/fd/0 /etc/resolv.conf <<'EOF'
  nameserver ${cidrhost(var.network.subnet, 1)}
  search ${var.network.domain}
  EOF

  $SHELL /etc/rc.local
  USERDATA
}
