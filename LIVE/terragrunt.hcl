generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
terraform {
  required_version = "1.1.8"
  required_providers {
    libvirt = {
      source  = "dmacvicar/libvirt"
      version = "0.6.14"
    }
  }
}
provider "libvirt" {
  uri = "qemu:///system"
}
EOF
}

remote_state {
  backend = "local"
  config = {}
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
}

terraform_binary = "${get_parent_terragrunt_dir()}/../bin/terraform"
