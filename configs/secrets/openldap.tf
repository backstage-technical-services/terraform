resource "random_password" "openldap_admin_password" {
  special = false
  length  = 30
}
resource "random_password" "openldap_config_password" {
  special = false
  length  = 30
}

module "openldap" {
  source = "../../modules/ssm-parameters"

  meta = { component = "openldap" }
  parameters = [
    {
      name      = "secrets"
      sensitive = true
      value = jsonencode({
        adminPassword  = nonsensitive(random_password.openldap_admin_password.result)
        configPassword = nonsensitive(random_password.openldap_config_password.result)
      })
    },
  ]
}
