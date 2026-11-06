module "phpldapadmin" {
  source = "../../modules/ssm-parameters"

  meta = { component = "phpldapadmin" }
  parameters = [
    {
      name          = "app-key"
      sensitive     = true
      initial_value = "empty"
    },
  ]
}
