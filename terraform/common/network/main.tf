resource "libvirt_network" "self" {
  name = var.network.name

  forward = {
    mode = "nat"
  }

  bridge = {
    name = var.network.name
    stp  = "on"
  }

  ips = [
    {
      address = cidrhost(var.network.subnet, 1)
      netmask = cidrnetmask(var.network.subnet)
    },
  ]

  domain = {
    name       = var.network.domain
    local_only = "yes"
  }

  dns = {
    enable = "yes"
    host = concat(
      [
        for k in range(0, var.nodes1.count) : {
          hostnames = [{ hostname = "${var.nodes1.prefix}${k + 1}" }]
          ip        = cidrhost(var.network.subnet, k + var.nodes1.offset)
        }
      ],
      [
        for k in range(0, var.nodes2.count) : {
          hostnames = [{ hostname = "${var.nodes2.prefix}${k + 1}" }]
          ip        = cidrhost(var.network.subnet, k + var.nodes2.offset)
        }
      ]
    )
  }

  autostart = true
}
