resource "random_pet" "admin_username" {
  length = 3
}
resource "random_password" "admin_password" {
  length = 25
}

module "ssm_parameters" {
  source = "../../modules/ssm-parameters"

  meta = local.meta
  parameters = [
    {
      name          = "db-credentials"
      sensitive     = true
      initial_value = jsonencode({ username = "", password = "" })
    },
    {
      name      = "admin-credentials"
      sensitive = true
      value = jsonencode({
        username = random_pet.admin_username.id
        password = nonsensitive(random_password.admin_password.result)
      })
    },
    {
      name          = "smtp-credentials"
      sensitive     = true
      initial_value = jsonencode({ username = "", password = "" })
    },
    {
      name          = "terraform-config"
      sensitive     = true
      initial_value = jsonencode({ clientId = "", clientSecret = "" })
    },
    {
      name          = "idp/google-alumni"
      sensitive     = true
      initial_value = jsonencode({ clientId = "", clientSecret = "" })
    },
  ]
}
