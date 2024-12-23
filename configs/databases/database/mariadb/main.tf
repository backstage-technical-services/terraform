variable "engine_version" {
  type = string
}
variable "default_annotations" {
  type = map(string)
}
variable "memory_limit" {
  type    = string
  default = null
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

  memory_limit = var.memory_limit
}

resource "random_password" "root_password" {
  length  = 20
  special = false
}
