locals {
  meta = {
    owner     = "backstage"
    component = try(regex("[^/]+$", path.cwd), "unknown")
  }
  default_tags = {
    managed-by = "Terraform"
    owner      = local.meta.owner
    repo       = "backstage/terraform"
    config     = local.meta.component
  }
  default_annotations = { for k, v in local.default_tags : "bnjns.uk/${k}" => v }
}

module "mariadb_10_4" {
  source = "./database/mariadb"

  engine_version      = "10.4"
  default_annotations = local.default_annotations

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

  engine_version      = "16"
  default_annotations = local.default_annotations

  resources = {
    requests = {
      memory = "1Gi"
    }
    limits = {
      memory = "2Gi"
    }
  }
}
