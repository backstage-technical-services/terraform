module "asset_database" {
  source = "./asset-database"

  for_each   = toset(["prod"])
  ssm_prefix = "/backstage/${each.key}/asset-database"
}

module "website_v4" {
  source = "./website-v4"

  for_each   = toset(["prod", "staging"])
  ssm_prefix = "/backstage/${each.key}/website-v4"
}

module "keycloak" {
  source = "./keycloak"

  ssm_prefix = "/backstage/keycloak"
}
