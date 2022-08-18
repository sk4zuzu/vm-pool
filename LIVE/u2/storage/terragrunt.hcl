locals {
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
}

terraform {
  source = "${get_parent_terragrunt_dir()}/../terraform//common/storage"
}

generate = local.environment_vars.generate

include {
  path = find_in_parent_folders()
}

inputs = {
  env     = local.environment_vars.locals.env
  storage = local.environment_vars.locals.storage
}
