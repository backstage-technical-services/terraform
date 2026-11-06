resource "random_password" "mariadb_10_4_root_password" {
  length  = 20
  special = false
}

resource "random_pet" "postgres_16_root_username" {
  length    = 3
  separator = "_"
}
resource "random_password" "postgres_16_root_password" {
  length = 30
}

module "database" {
  source = "../../modules/ssm-parameters"

  meta = { component = "database" }
  parameters = [
    {
      name      = "mariadb-10-4"
      sensitive = true
      value = jsonencode({
        MARIADB_ROOT_PASSWORD = nonsensitive(random_password.mariadb_10_4_root_password.result)
      })
    },
    {
      name      = "postgres-16"
      sensitive = true
      value = jsonencode({
        POSTGRES_USER     = random_pet.postgres_16_root_username.id
        POSTGRES_PASSWORD = nonsensitive(random_password.postgres_16_root_password.result)
      })
    },
  ]
}
