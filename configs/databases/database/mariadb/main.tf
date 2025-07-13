module "this" {
  source = "../_db"

  default_labels = var.default_labels

  engine         = "mariadb"
  engine_version = var.engine_version
  port           = 3306

  data_dir        = "/var/lib/mysql"
  storage_size    = var.storage_size
  access_point_id = var.access_point_id

  secrets = {
    MARIADB_ROOT_PASSWORD = random_password.root_password.result
  }
  env = {
    MARIADB_ROOT_HOST = "localhost"
  }

  resources = var.resources
}

resource "random_password" "root_password" {
  length  = 20
  special = false
}
