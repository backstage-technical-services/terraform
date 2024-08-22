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
}
