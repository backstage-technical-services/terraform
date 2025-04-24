terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

variable "domain_name" {
  type = string
}

variable "records" {
  type = list(object({
    name    = string
    type    = string
    records = list(string)
    ttl     = optional(number, 60)
  }))
}
