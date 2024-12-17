terraform {
  required_providers {
    kubernetes = {
      source = "hashicorp/kubernetes"
    }
  }
}

variable "default_annotations" {
  type = map(string)
}

variable "engine" {
  type = string
}
variable "engine_version" {
  type = string
}
variable "data_dir" {
  type = string
}
variable "port" {
  type = number
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
variable "memory_limit" {
  type    = string
  default = null
}
