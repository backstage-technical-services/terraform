module "infrastructure" {
  source   = "./infrastructure"
  for_each = toset(["prod"])

  meta = merge(local.meta, {
    environment = each.key
  })
}
