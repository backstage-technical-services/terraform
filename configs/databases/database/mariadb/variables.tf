terraform {
  required_providers {
    random = {
      source = "hashicorp/random"
    }
  }
}

variable "engine_version" {
  type = string
}
variable "default_labels" {
  type = map(string)
}
variable "storage_size" {
  type = string
}
variable "access_point_id" {
  type = string
}
variable "resources" {
  type = object({
    requests = optional(object({
      cpu    = optional(string)
      memory = optional(string)
    }))
    limits = optional(object({
      cpu    = optional(string)
      memory = optional(string)
    }))
  })
  default = null
}
