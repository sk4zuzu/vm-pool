locals {
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
}

terraform {
  source = "${get_parent_terragrunt_dir()}/../terraform//centos/nodes"
}

include {
  path = find_in_parent_folders("root.hcl")
}

dependencies {
  paths = ["../network", "../storage"]
}

inputs = {
  running = local.environment_vars.locals.running
  env     = local.environment_vars.locals.env
  network = local.environment_vars.locals.network
  storage = local.environment_vars.locals.storage
  nodes   = local.environment_vars.locals.nodes1
}
