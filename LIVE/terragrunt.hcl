generate "terraform" {
  path      = "terraform.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
terraform {
  required_version = "1.11.1"
  required_providers {
    libvirt = {
      source  = "dmacvicar/libvirt"
      version = "0.8.3"
    }
  }
}
EOF
}

generate "provider" {
  path      = "provider.tf"
  if_exists = "skip"
  contents  = <<EOF
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
