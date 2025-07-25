data "aws_security_group" "node_group_standard_arm64" {
  name = "bnjns-eks-node-standard-arm64"
}

module "node_group" {
  source = "git@github.com:bnjns/terraform.git//configs/eks/node-group?ref=44743eddd1b62cdaeedbf2776c9658cf89607f58"

  name         = "backstage"
  owner        = "backstage"
  cluster_name = "bnjns"

  instance_types  = ["t4g.large"]
  instance_arch   = "arm64"
  release_version = "1.33.0-20250627"

  vpc_id         = data.terraform_remote_state.base_infra.outputs.vpc.vpc_id
  vpc_subnet_ids = data.terraform_remote_state.base_infra.outputs.vpc.private_subnet_ids

  additional_security_rules = [
    {
      type           = "ingress"
      description    = "Allow traffic from ${data.aws_security_group.node_group_standard_arm64.name} nodes on ephemeral ports"
      protocol       = "tcp"
      from_port      = 1025
      to_port        = 65535
      security_group = data.aws_security_group.node_group_standard_arm64.id
    },
  ]

  min_size = 1
  max_size = 1

  node_labels = {
    "bnjns.uk/owner" = "backstage"
  }
  node_taints = {
    "bnjns.uk/reserved-for" = "backstage"
  }
}
