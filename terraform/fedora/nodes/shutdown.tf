resource "terraform_data" "fedora" {
  depends_on = [libvirt_domain.nodes]

  count = var.shutdown ? var.nodes.count : 0

  triggers_replace = [uuid()]

  provisioner "local-exec" {
    command = <<-EOF
    ssh $SSH_OPTS $SSH_USER@$SSH_HOST -- sudo poweroff || true
    EOF
    environment = {
      SSH_OPTS = "-o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null"
      SSH_USER = "fedora"
      SSH_HOST = cidrhost(var.network.subnet, count.index + var.nodes.offset)
    }
    interpreter = ["bash", "-c"]
  }
}
