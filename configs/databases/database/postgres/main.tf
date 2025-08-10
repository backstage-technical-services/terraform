module "this" {
  source = "../_db"

  default_labels = var.default_labels

  engine         = "postgres"
  engine_version = var.engine_version
  port           = 5432

  data_dir        = "/var/lib/postgresql/data"
  storage_size    = var.storage_size
  access_point_id = var.access_point_id

  env = {
    PGDATA = "/var/lib/postgresql/data"
  }

  secrets = {
    POSTGRES_USER     = random_pet.root_username.id
    POSTGRES_PASSWORD = random_password.root_password.result
  }

  resources = var.resources
}

resource "random_pet" "root_username" {
  length    = 3
  separator = "_"
}

resource "random_password" "root_password" {
  length = 30
}
