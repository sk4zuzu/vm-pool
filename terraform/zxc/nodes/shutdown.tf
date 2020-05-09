
resource null_resource "zxc" {
  depends_on = [ libvirt_domain.nodes ]

  count = var.shutdown ? var._count : 0

  triggers = {
    always = uuid()
  }

  provisioner "local-exec" {
    command = <<-EOF
    ssh $SSH_OPTS $SSH_USER@$SSH_HOST -- sudo poweroff || true
    EOF
    environment = {
      SSH_OPTS = "-o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null"
      SSH_USER = "cloud-user"
      SSH_HOST = cidrhost(var.subnet, count.index + var._ipgap)
    }
    interpreter = ["bash", "-c"]
  }
}

# vim:ts=2:sw=2:et:syn=terraform:
