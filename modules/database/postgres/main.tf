variable "engine_version" {
  type = string
}
variable "default_annotations" {
  type = map(string)
}

module "this" {
  source = "../_db"

  default_annotations = var.default_annotations

  engine         = "postgres"
  engine_version = var.engine_version
  port           = 5432
  data_dir       = "/var/lib/postgresql"

  secrets = {
    POSTGRES_USER     = random_pet.root_username.id
    POSTGRES_PASSWORD = random_password.root_password.result
  }
}

resource "random_pet" "root_username" {
  length    = 3
  separator = "_"
}

resource "random_password" "root_password" {
  length = 30
}
