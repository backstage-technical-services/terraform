locals {
  default_tags = {
    managed-by = "Terraform"
    owner      = "backstage"
    repo       = "backstage/terraform"
    config     = try(regex("[^/]+$", path.cwd), "unknown")
  }
}

resource "aws_route53_zone" "bts_crew_com" {
  name = "bts-crew.com"
}

data "aws_eip" "k3s_node" {
  filter {
    name   = "tag:Name"
    values = ["backstage-k3s-worker"]
  }
}
