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
}


terraform {
  required_version = "~> 1.7"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }

  backend "s3" {
    bucket         = "bnjns-terraform"
    key            = "backstage/eks.tfstate"
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
