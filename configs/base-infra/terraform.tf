data "aws_region" "current" {}
data "aws_caller_identity" "current" {}

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

terraform {
  required_version = "~> 1.10"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    bucket       = "bnjns-terraform"
    key          = "backstage/base-infra.tfstate"
    encrypt      = true
    region       = "eu-west-1"
    profile      = "backstage"
    use_lockfile = true
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
