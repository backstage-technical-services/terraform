module "mariadb_10_4" {
  source = "./database/mariadb"

  engine_version = "10.4"
  default_labels = local.default_labels

  storage_size    = "5Gi"
  access_point_id = "fsap-0361b21e64ee2c4fc"

  resources = {
    requests = {
      memory = "256Mi"
    }
    limits = {
      memory = "512Mi"
    }
  }
}

module "postgres_16" {
  source = "./database/postgres"

  engine_version = "16"
  default_labels = local.default_labels

  storage_size    = "5Gi"
  access_point_id = "fsap-0446cf8754d287202"

  resources = {
    requests = {
      memory = "1Gi"
    }
    limits = {
      memory = "2Gi"
    }
  }
}
