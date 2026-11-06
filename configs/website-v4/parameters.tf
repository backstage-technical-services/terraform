module "ssm_parameters" {
  source = "../../modules/ssm-parameters"

  for_each = toset(["staging", "prod"])

  meta = merge(local.meta, {
    environment = each.key
  })
  parameters = [
    { name = "app-key", sensitive = true },
    { name = "backup-webhook", sensitive = true },
    { name = "bugsnag-api-key", sensitive = true },
    {
      name          = "db-credentials"
      sensitive     = true
      initial_value = jsonencode({ username = "", password = "" })
    },
    { name = "finance-db-key", sensitive = true },
    {
      name          = "keycloak-credentials"
      sensitive     = true
      initial_value = jsonencode({ clientId = "", clientSecret = "" })
    },
    { name = "log-level", sensitive = false },
    {
      name          = "nocaptcha-config"
      sensitive     = true
      initial_value = jsonencode({ siteKey = "", secret = "" })
    },
    {
      name          = "smtp-credentials"
      sensitive     = true
      initial_value = jsonencode({ username = "", password = "" })
    },
    { name = "youtube-api-key", sensitive = true },
  ]
}
