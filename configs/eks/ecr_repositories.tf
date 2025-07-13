locals {
  ecr_repositories = [
    "asset-database",
    "keycloak",
    "website-v4",
  ]
}

module "ecr_repository" {
  source = "./ecr-repository"

  for_each  = toset(local.ecr_repositories)
  component = each.key
}
