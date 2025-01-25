locals {
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
}

terraform {
  source = "${get_parent_terragrunt_dir()}/../terraform//debian32/nodes"
}

include {
  path = find_in_parent_folders()
}

dependencies {
  paths = ["../network", "../storage"]
}

inputs = {
  shutdown = local.environment_vars.locals.shutdown
  env      = local.environment_vars.locals.env
  network  = local.environment_vars.locals.network
  storage  = local.environment_vars.locals.storage
  nodes    = local.environment_vars.locals.nodes1
}
