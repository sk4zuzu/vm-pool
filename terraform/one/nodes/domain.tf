locals {
  xslt = <<-XSLT
    <?xml version="1.0"?>
    <xsl:stylesheet version="1.0"
                    xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

      <xsl:output omit-xml-declaration="yes" indent="yes"/>
      <xsl:template match="node()|@*">
          <xsl:copy>
             <xsl:apply-templates select="node()|@*"/>
          </xsl:copy>
       </xsl:template>

      <xsl:template match="/domain">
        <xsl:copy>
            <xsl:apply-templates select="node()|@*"/>
            <xsl:element name ="memoryBacking">
                <xsl:element name="source">
                    <xsl:attribute name="type">memfd</xsl:attribute>
                </xsl:element>
                <xsl:element name="access">
                    <xsl:attribute name="mode">shared</xsl:attribute>
                </xsl:element>
            </xsl:element>
        </xsl:copy>
      </xsl:template>

      <xsl:template match="/domain/devices">
        <xsl:copy>
            <xsl:apply-templates select="node()|@*"/>
            <xsl:element name ="filesystem">
                <xsl:attribute name="type">mount</xsl:attribute>
                <xsl:attribute name="accessmode">passthrough</xsl:attribute>
                <xsl:element name="driver">
                    <xsl:attribute name="type">virtiofs</xsl:attribute>
                </xsl:element>
                <xsl:element name="source">
                    <xsl:attribute name="dir">/home/asd/_git/</xsl:attribute>
                </xsl:element>
                <xsl:element name="target">
                    <xsl:attribute name="dir">asd</xsl:attribute>
                </xsl:element>
                <xsl:element name="address">
                    <xsl:attribute name="type">pci</xsl:attribute>
                    <xsl:attribute name="domain">0x0000</xsl:attribute>
                    <xsl:attribute name="bus">0x07</xsl:attribute>
                    <xsl:attribute name="slot">0x01</xsl:attribute>
                    <xsl:attribute name="function">0x0</xsl:attribute>
                </xsl:element>
            </xsl:element>
        </xsl:copy>
      </xsl:template>

    </xsl:stylesheet>
  XSLT
}

resource "libvirt_domain" "nodes" {
  count  = var.nodes.count
  name   = "${var.nodes.prefix}${count.index + 1}"
  vcpu   = var.nodes.vcpu
  memory = var.nodes.memory

  cloudinit = libvirt_cloudinit_disk.nodes.*.id[count.index]

  cpu {
    mode = "host-passthrough"
  }

  network_interface {
    bridge         = var.network.name
    wait_for_lease = false
  }

  console {
    type        = "pty"
    target_port = "0"
    target_type = "serial"
  }

  console {
    type        = "pty"
    target_type = "virtio"
    target_port = "1"
  }

  disk {
    volume_id = libvirt_volume.nodes.*.id[count.index]
  }

  graphics {
    type           = "vnc"
    listen_type    = "address"
    listen_address = "127.0.0.1"
    autoport       = true
  }

  autostart = !var.shutdown

  xml {
    xslt = local.xslt
  }
}
