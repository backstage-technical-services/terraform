terraform {
  required_providers {
    kubernetes = {
      source = "hashicorp/kubernetes"
    }
  }
}

variable "default_labels" {
  type = map(string)
}

variable "engine" {
  type = string
}
variable "engine_version" {
  type = string
}
variable "port" {
  type = number
}

// Data storage
variable "data_dir" {
  type = string
}
variable "storage_size" {
  type = string
}
variable "access_point_id" {
  type = string
}

variable "secrets" {
  type      = map(string)
  default   = {}
  sensitive = true
}
variable "env" {
  type    = map(string)
  default = {}
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
