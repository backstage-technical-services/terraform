terraform {
  required_version = "~> 1.7"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
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
data "aws_ssm_parameter" "kubernetes_config" {
  name = "/backstage/kubernetes/kube-config"
}
locals {
  kube_config = jsondecode(data.aws_ssm_parameter.kubernetes_config.value)
}
provider "kubernetes" {
  host = "https://k3s.bnjns.uk:6443"

  cluster_ca_certificate = local.kube_config["cluster_ca_certificate"]
  client_certificate     = local.kube_config["client_certificate"]
  client_key             = local.kube_config["client_key"]
}
