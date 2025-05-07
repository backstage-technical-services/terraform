locals {
  canonical_owner_id = "099720109477"
}

data "aws_ami" "default" {
  most_recent = true
  owners      = [local.canonical_owner_id]

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "architecture"
    values = ["arm64"]
  }

  filter {
    name   = "name"
    values = ["ubuntu-minimal/images/hvm-ssd/ubuntu-*-22.04-*"]
  }
}

data "aws_instance" "master_node" {
  filter {
    name   = "tag:Name"
    values = ["bnjns-k3s-master"]
  }

  filter {
    name   = "instance-state-name"
    values = ["running"]
  }
}

module "node" {
  source = "git@github.com:bnjns/terraform.git//configs/k3s/worker-node" # tflint-ignore: terraform_module_pinned_source

  meta          = local.meta
  ami           = data.aws_ami.default
  instance_type = "t4g.large"
  vpc           = data.terraform_remote_state.base_infra.outputs.vpc

  instance_profile_arn        = data.aws_iam_instance_profile.master_node.arn
  node_secrets_parameter_name = "/bnjns/k3s/node-secrets"
  master_node_ip              = data.aws_instance.master_node.private_ip

  node_labels = {
    "bnjns.uk/owner" = "backstage"
  }
  node_taints = {
    "bnjns.uk/reserved-for" = "backstage"
  }

  volumes = {
    sdf = aws_ebs_volume.node_data.id
  }
  mount_points = {
    "9e935f8e-e148-4a0d-9998-8727d5a83596" = "/opt/data/backstage"
  }
}
