locals {
  nic = "Ethernet 2"
}

resource "libvirt_cloudinit_disk" "nodes" {
  count = var.nodes.count
  name  = "${var.nodes.prefix}${count.index + 1}.iso"

  meta_data = <<-EOF
  local-hostname: ${var.nodes.prefix}${count.index + 1}
  EOF

  user_data = <<-EOF
  #cloud-config
  write_files:
    - path: C:\Network.ps1
      content: |
        New-NetIPAddress `
        -InterfaceAlias "${local.nic}" `
        -IPAddress "${cidrhost(var.network.subnet, count.index + var.nodes.offset)}" `
        -PrefixLength "${split("/", var.network.subnet).1}" `
        -DefaultGateway "${cidrhost(var.network.subnet, 1)}" `
        -ErrorAction SilentlyContinue
        Set-DnsClientServerAddress `
        -InterfaceAlias "${local.nic}" `
        -ServerAddresses ("${cidrhost(var.network.subnet, 1)}", "1.1.1.1") `
        -ErrorAction SilentlyContinue
  runcmd:
    - powershell.exe -File C:\Network.ps1
  EOF
}
