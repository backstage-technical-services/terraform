module "ssm_parameters" {
  source = "../../modules/ssm-parameters"

  for_each = toset(["prod"])

  meta = merge(local.meta, {
    environment = each.key
  })
  parameters = [
    { name = "secret-key", sensitive = true },
    {
      name          = "db-credentials"
      sensitive     = true
      initial_value = jsonencode({ username = "", password = "" })
    },
    {
      name          = "smtp-credentials"
      sensitive     = true
      initial_value = jsonencode({ username = "", password = "" })
    },
  ]
}
