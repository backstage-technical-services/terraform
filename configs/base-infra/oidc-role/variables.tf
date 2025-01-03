terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

variable "name" {
  type = string
}
variable "repositories" {
  type = list(string)
}

variable "policy_arns" {
  type    = list(string)
  default = []
}
variable "inline_policies" {
  type    = map(string)
  default = {}
}

variable "allowed_branches" {
  type    = list(string)
  default = []
}
variable "allowed_environments" {
  type    = list(string)
  default = []
}
variable "allow_pull_requests" {
  type    = bool
  default = false
}
