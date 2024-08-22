module "infrastructure" {
  source   = "./infrastructure"
  for_each = toset(["staging", "prod"])

  meta = merge(local.meta, {
    environment = each.key
  })
}
