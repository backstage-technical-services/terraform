variable "engine_version" {
  type = string
}
variable "default_annotations" {
  type = map(string)
}

module "this" {
  source = "../_db"

  default_annotations = var.default_annotations

  engine         = "mariadb"
  engine_version = var.engine_version
  port           = 3306
  data_dir       = "/var/lib/mysql"

  secrets = {
    MARIADB_ROOT_PASSWORD = random_password.root_password.result
  }
  env = {
    MARIADB_ROOT_HOST = "localhost"
  }
}

resource "random_password" "root_password" {
  length  = 20
  special = false
}
