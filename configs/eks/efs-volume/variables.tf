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
variable "tags" {
  type = map(string)
}

// Networking
variable "vpc_id" {
  type = string
}
variable "private_subnet_ids" {
  type = list(string)
}
variable "node_security_group_id" {
  type = string
}

// EFS
variable "access_points" {
  type = list(object({
    directory = string
    uid       = optional(number, 0)
    gid       = optional(number, 0)
  }))
  description = "A list of directories on the EFS to create access points for."
  default     = []
}
