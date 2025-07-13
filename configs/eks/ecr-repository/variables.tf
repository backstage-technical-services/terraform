terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

// Common config
variable "component" {
  type = string
}
variable "tags" {
  type    = map(string)
  default = {}
}

// ECR
variable "expire_untagged_images_after" {
  type        = number
  description = "The number of days after which untagged images should be removed from the ECR."
  default     = 14
}
variable "num_images_to_keep" {
  type        = number
  description = "The maximum number of images to keep in the ECR."
  default     = 10
}
