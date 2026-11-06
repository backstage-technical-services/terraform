module "ecr_repository" {
  source    = "../../modules/ecr-repository"
  component = local.meta.component
}
