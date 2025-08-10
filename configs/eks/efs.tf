module "data_efs" {
  source = "./efs-volume"

  name = "backstage-data"
  tags = local.default_tags

  vpc_id                 = data.terraform_remote_state.base_infra.outputs.vpc.vpc_id
  private_subnet_ids     = data.terraform_remote_state.base_infra.outputs.vpc.private_subnet_ids
  node_security_group_id = module.node_group.security_group_id

  access_points = [
    { directory = "/database/mariadb-10-4", uid = 999, gid = 999 },
    { directory = "/database/postgres-16", uid = 0, gid = 0 },
    { directory = "/website-v4/prod", uid = 82, gid = 82 },
    { directory = "/website-v4/staging", uid = 82, gid = 82 },
  ]
}
