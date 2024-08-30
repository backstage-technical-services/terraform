locals {
  engine_config = {
    mariadb = {
      port                        = 3306
      root_password_variable_name = "MARIADB_ROOT_PASSWORD"
      data_dir                    = "/var/lib/mysql"
      env_variables = {
        MARIADB_ROOT_HOST = "localhost"
      }
    }
  }
}
