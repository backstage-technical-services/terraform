terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

variable "meta" {
  type = object({
    environment = optional(string)
    component   = optional(string)
  })
  nullable = false
  default  = {}
}

variable "tags" {
  type     = map(string)
  nullable = false
  default  = {}
}

variable "parameters" {
  type = list(object({
    name          = string
    sensitive     = optional(bool, true)
    initial_value = optional(string, "dummy")
    value         = optional(string)
  }))
  nullable = false
}
