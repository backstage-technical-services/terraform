variable "engine_version" {
  type = string
}
variable "default_annotations" {
  type = map(string)
}
variable "resources" {
  type = object({
    requests = optional(object({
      cpu    = optional(string)
      memory = optional(string)
    }))
    limits = optional(object({
      cpu    = optional(string)
      memory = optional(string)
    }))
  })
  default = null
}

module "this" {
  source = "../_db"

  default_annotations = var.default_annotations

  engine         = "postgres"
  engine_version = var.engine_version
  port           = 5432
  data_dir       = "/var/lib/postgresql/data"

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
