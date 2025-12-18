locals {
  pubkeys = flatten([[
    for v in split("\n", var.nodes.keys) : trimspace(v) if trimspace(v) != ""
  ]])
  write_files = [
    {
      path = "/etc/nixos/configuration.nix.d/01-mounts.nix"
      content = join("\n", [
        "{ ... }: {",
        chomp(join("", [
          for v in var.nodes.mounts :
          <<-EOT
            fileSystems."${trimsuffix(v.path, "/")}" = {
              device  = "${v.target}";
              fsType  = "9p";
              options = [ "trans=virtio" "version=9p2000.L" "${v.ro ? "r" : "rw"}" ];
            };
          EOT
        ])),
        "}",
      ])
    },
    {
      path = "/var/tmp/setup.sh"
      content = chomp(
        <<-EOF
          ((!DETACHED)) && DETACHED=1 exec setsid --fork "$SHELL" "$0" "$@"
          nixos-rebuild switch
        EOF
      )
    },
  ]
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
    eth1:
      dhcp4: false
      dhcp6: false
    eth2:
      dhcp4: false
      dhcp6: false
  EOF

  user_data = <<-EOF
  #cloud-config
  users:
    - name: asd
      ssh_authorized_keys: ${jsonencode(local.pubkeys)}
    - name: root
      ssh_authorized_keys: ${jsonencode(local.pubkeys)}
  write_files: ${jsonencode(local.write_files)}
  runcmd:
    - systemctl restart systemd-resolved.service
    - /run/current-system/sw/bin/bash --login /var/tmp/setup.sh
  EOF
}
