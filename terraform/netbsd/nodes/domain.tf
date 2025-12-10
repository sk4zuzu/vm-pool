resource "libvirt_domain" "nodes" {
  count = var.nodes.count
  name  = "${var.nodes.prefix}${count.index + 1}"

  type = "kvm"

  os = {
    type         = "hvm"
    type_arch    = "x86_64"
    type_machine = "q35"
  }

  features = { acpi = true } # required, otherwise keyboard may not work

  cpu  = { mode = "host-passthrough" }
  vcpu = var.nodes.vcpu

  memory      = var.nodes.memory
  memory_unit = "MiB"

  devices = {
    disks = [
      {
        boot   = { order = 1 }
        driver = { type = "qcow2" } # required, otherwise "raw" driver is used
        source = {
          volume = {
            pool   = var.storage.pool
            volume = libvirt_volume.nodes_root[count.index].name
          }
        }
        target = {
          dev = "vda"
          bus = "virtio"
        }
      },
      {
        device = "cdrom"
        driver = { type = "raw" }
        source = {
          file = {
            file = libvirt_volume.nodes_init[count.index].path
          }
        }
        target = {
          dev = "sdd"
          bus = "sata"
        }
      },
    ]
    interfaces = concat(
      [
        {
          type   = "network"
          model  = { type = "virtio" }
          source = { network = { network = var.network.name } }
        },
      ],
      [
        for v in ["${var.env}none1", "${var.env}none2"] : {
          type   = "network"
          model  = { type = "virtio" }
          source = { network = { network = v } }
        }
      ]
    )
    graphics = [
      {
        vnc = {
          listen    = "127.0.0.1"
          auto_port = true
        }
      },
    ]
  }

  running   = var.running
  autostart = false
}
