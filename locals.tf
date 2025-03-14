locals {
  values     = yamldecode(var.values[0])
  app_config = local.values.global.appConfig

  omniauth_providers = {
    for k, v in local.values.global.appConfig.omniauth.providers :
    k => v.secret
  }

  buckets_app = {
    for k, v in local.app_config :
    k => v
    if k == "lfs" || k == "artifacts" || k == "packages" || k == "uploads" || k == "externalDiffs" || k == "terraformState" || k == "ciSecureFiles" || k == "dependencyProxy"
  }

  registry = {
    for k, v in local.values :
    k => v
    if k == "registry"
  }

  buckets_list = merge(
    {
      for k, v in local.buckets_app :
      k => v.bucket if v.enabled == true
    },
    {
      for k, v in local.registry :
      k => v.bucket if v.enabled == true
    },
    {
      backup : local.values.global.appConfig.backups.bucket
      backup_tmp : local.values.global.appConfig.backups.tmpBucket
    }
  )

  decoded_buckets_lifecycles = { for bucket, config in var.buckets_lifecycles :
    bucket => jsondecode(config)
  }

  # Filter only buckets with a non-empty lifecycle_rule
  filtered_buckets_lifecycles = {
    for bucket, config in local.decoded_buckets_lifecycles :
    bucket => config if length(try(config.lifecycle_rule, [])) > 0
  }
}
