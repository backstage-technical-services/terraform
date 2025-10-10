terraform {
  required_version = "~> 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 6.0.0"
    }
  }
}

// Bucket config
variable "name" {
  type        = string
  description = "The name of the bucket."
}
variable "tags" {
  type        = map(string)
  description = "A map of tags to attach to every resource."
  default     = {}
}
variable "enable_public_access" {
  type        = bool
  description = "Enables public read access for all objects."
  default     = false
}
variable "enable_analytics" {
  type        = bool
  description = "Whether to enable storage class analytics."
  default     = true
}

// CORS
variable "enable_cors" {
  type        = bool
  description = "Whether to enable CORS configuration on the S3 bucket."
  default     = false
}
variable "cors_allowed_methods" {
  type        = list(string)
  description = "The list of HTTP methods that CORS allows."
  default     = ["HEAD", "GET"]
}
variable "cors_allowed_origins" {
  type        = list(string)
  description = "The list of origins that CORS allows."
  default     = []
}
variable "cors_allowed_headers" {
  type        = list(string)
  description = "The list of headers that CORS allows."
  default     = []
}

// Lifecycle configuration
variable "expire_incomplete_uploads_after" {
  type        = number
  description = "The number of days after which incomplete multipart uploads will be deleted."
  default     = 7

  validation {
    condition     = var.expire_incomplete_uploads_after > 0
    error_message = "The value of expire_incomplete_uploads_after must be greater than 0."
  }
}
variable "expire_objects_after" {
  type        = number
  description = "The number of days after which objects will be expired."
  default     = null

  validation {
    condition     = var.expire_objects_after == null || var.expire_objects_after > 0
    error_message = "The value of expire_objects_after must be greater than 0."
  }
}
variable "expire_noncurrent_objects_after" {
  type        = number
  description = "The number of days after which noncurrent (previous version) objects will be expired. Will only be applied if `var.expire_objects_after` is set."
  default     = 30

  validation {
    condition     = var.expire_noncurrent_objects_after > 0
    error_message = "The value of expire_noncurrent_objects_after must be greater than 0."
  }
}
variable "transition_objects_after" {
  type        = number
  description = "The number of days after which objects are transitioned to the `var.transition_objects_to` storage class."
  default     = null

  validation {
    condition     = var.transition_objects_after == null || var.transition_objects_after > 0
    error_message = "The value of transition_objects_after must be greater than 0."
  }
}
variable "transition_objects_to" {
  type        = string
  description = "The storage class to transition objects to, if `var.transition_objects_after` is configured."
  default     = "INTELLIGENT_TIERING"

  validation {
    condition     = contains(["DEEP_ARCHIVE", "GLACIER", "GLACIER_IR", "INTELLIGENT_TIERING", "ONEZONE_IA", "STANDARD_IA"], var.transition_objects_to)
    error_message = "The value of transition_objects_to must be one of: DEEP_ARCHIVE, GLACIER, GLACIER_IR, INTELLIGENT_TIERING, ONEZONE_IA, STANDARD_IA."
  }
}
variable "transition_noncurrent_objects_after" {
  type        = number
  description = "The number of days after which noncurrent (previous version) objects are transitioned to the `var.transition_noncurrent_objects_to` storage class. Will only be applied if `var.transition_objects_after` is set."
  default     = 1
}
variable "transition_noncurrent_objects_to" {
  type        = string
  description = "The storage class to transition objects to, if `var.transition_objects_after` is configured."
  default     = "GLACIER"

  validation {
    condition     = contains(["DEEP_ARCHIVE", "GLACIER", "GLACIER_IR", "INTELLIGENT_TIERING", "ONEZONE_IA", "STANDARD_IA"], var.transition_noncurrent_objects_to)
    error_message = "The value of transition_objects_to must be one of: DEEP_ARCHIVE, GLACIER, GLACIER_IR, INTELLIGENT_TIERING, ONEZONE_IA, STANDARD_IA."
  }
}
variable "custom_lifecycle_rules" {
  type = map(object({
    enabled = optional(bool, true)
    expiration = optional(object({
      date = optional(string)
      days = optional(number)
    }))
    filter = optional(object({
      and = optional(object({
        object_size_greater_than = optional(number)
        object_size_less_than    = optional(number)
        prefix                   = optional(string)
        tags                     = optional(map(string))
      }))
      object_size_greater_than = optional(number)
      object_size_less_than    = optional(number)
      prefix                   = optional(string)
      tag = optional(object({
        key   = string
        value = string
      }))
    }))
    noncurrent_version_expiration = optional(object({
      newer_noncurrent_versions = optional(number)
      noncurrent_days           = number
    }))
    noncurrent_version_transition = optional(object({
      newer_noncurrent_versions = optional(number)
      noncurrent_days           = number
      storage_class             = string
    }))
    transition = optional(object({
      date          = optional(string)
      days          = optional(number)
      storage_class = string
    }))
  }))
  description = "A map of custom lifecycle rules to apply to the bucket, where the key is the rule ID. See <https://docs.aws.amazon.com/AmazonS3/latest/userguide/object-lifecycle-mgmt.html>."
  default     = {}
}
