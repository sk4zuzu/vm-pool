resource "null_resource" "openbsd" {
  depends_on = [libvirt_domain.nodes]

  count = var.shutdown ? var.nodes.count : 0

  triggers = {
    always = uuid()
  }

  provisioner "local-exec" {
    command = <<-EOF
    ssh $SSH_OPTS $SSH_USER@$SSH_HOST -- sudo halt -p || true
    EOF
    environment = {
      SSH_OPTS = "-o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null"
      SSH_USER = "openbsd"
      SSH_HOST = cidrhost(var.network.subnet, count.index + var.nodes.offset)
    }
    interpreter = ["bash", "-c"]
  }
}
