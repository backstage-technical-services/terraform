locals {
  meta = {
    owner  = "backstage"
    config = try(regex("configs/(.*)$", path.cwd)[0], "unknown")
  }
  default_tags = {
    managed-by = "Terraform"
    owner      = local.meta.owner
    repo       = "backstage/terraform"
    config     = local.meta.config
  }
  default_labels = { for k, v in local.default_tags : "bnjns.uk/${k}" => v if !strcontains(v, "/") }
}


terraform {
  required_version = "~> 1.7"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.0"
    }
  }

  backend "s3" {
    bucket         = "bnjns-terraform"
    key            = "backstage/kubernetes.tfstate"
    dynamodb_table = "bnjns-terraform-lock"
    encrypt        = true
    region         = "eu-west-1"
    profile        = "backstage"
  }
}


########################################################################################################################
# AWS
########################################################################################################################
provider "aws" {
  region  = "eu-west-1"
  profile = "backstage"

  default_tags {
    tags = local.default_tags
  }
}

########################################################################################################################
# Kubernetes
########################################################################################################################
data "aws_eks_cluster" "bnjns" {
  name = "bnjns"
}
data "aws_eks_cluster_auth" "bnjns" {
  name = data.aws_eks_cluster.bnjns.name
}
provider "kubernetes" {
  host                   = data.aws_eks_cluster.bnjns.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.bnjns.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.bnjns.token
}
