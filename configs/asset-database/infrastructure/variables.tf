terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

variable "meta" {
  type = object({
    owner       = string
    environment = string
    component   = string
  })
}
