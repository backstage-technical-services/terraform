terraform {
  required_providers {
    kubernetes = {
      source = "hashicorp/kubernetes"
    }
  }
}

variable "engine" {
  type = string

  validation {
    condition     = contains(["mariadb"], var.engine)
    error_message = "The engine must be one of: mariadb."
  }
}
variable "engine_version" {
  type = string
}
variable "default_annotations" {
  type = map(string)
}
