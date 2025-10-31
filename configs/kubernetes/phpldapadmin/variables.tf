terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
    kubernetes = {
      source = "hashicorp/kubernetes"
    }
    random = {
      source = "hashicorp/random"
    }
  }
}

variable "namespace" {
  type = string
}
variable "labels" {
  type = map(string)
}
variable "openldap_secrets_parameter" {
  type = string
}
