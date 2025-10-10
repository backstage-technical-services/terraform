data "aws_caller_identity" "this" {}
data "aws_region" "current" {}

locals {
  create_bucket_policy = var.enable_public_access
}

resource "aws_s3_bucket" "default" {
  bucket = var.name
  tags   = var.tags

  force_destroy = true
}

resource "aws_s3_bucket_ownership_controls" "default" {
  bucket = aws_s3_bucket.default.id

  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "default" {
  bucket = aws_s3_bucket.default.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_versioning" "default" {
  bucket = aws_s3_bucket.default.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_public_access_block" "default" {
  bucket = aws_s3_bucket.default.id

  block_public_acls       = !var.enable_public_access
  block_public_policy     = !var.enable_public_access
  ignore_public_acls      = !var.enable_public_access
  restrict_public_buckets = !var.enable_public_access
}

resource "aws_s3_bucket_cors_configuration" "default" {
  count = var.enable_cors ? 1 : 0

  bucket = aws_s3_bucket.default.id

  cors_rule {
    allowed_methods = var.cors_allowed_methods
    allowed_origins = var.cors_allowed_origins
    allowed_headers = var.cors_allowed_headers

    expose_headers = ["Access-Control-Allow-Origin"]
  }
}

data "aws_iam_policy_document" "bucket_policy" {
  count = local.create_bucket_policy ? 1 : 0

  dynamic "statement" {
    for_each = var.enable_public_access ? [1] : []

    content {
      actions   = ["s3:GetObject"]
      resources = ["${aws_s3_bucket.default.arn}/*"]

      principals {
        identifiers = ["*"]
        type        = "*"
      }
    }
  }
}
resource "aws_s3_bucket_policy" "default" {
  count = local.create_bucket_policy ? 1 : 0

  bucket = aws_s3_bucket.default.id
  policy = data.aws_iam_policy_document.bucket_policy[0].json

  depends_on = [
    aws_s3_bucket_public_access_block.default,
  ]
}

resource "aws_s3_bucket_analytics_configuration" "default" {
  count = var.enable_analytics ? 1 : 0

  bucket = aws_s3_bucket.default.id
  name   = "EntireBucket"
}

resource "aws_s3_bucket_lifecycle_configuration" "default" {
  bucket = aws_s3_bucket.default.id

  rule {
    id     = "ExpireDeleteMarkersAndIncompleteMultipartUploads"
    status = "Enabled"

    filter {}

    abort_incomplete_multipart_upload {
      days_after_initiation = var.expire_incomplete_uploads_after
    }

    expiration {
      expired_object_delete_marker = true
    }
  }

  dynamic "rule" {
    for_each = var.expire_objects_after != null ? [1] : []

    content {
      id     = "ExpireObjects"
      status = "Enabled"

      filter {}

      expiration {
        days = var.expire_objects_after
      }

      noncurrent_version_expiration {
        noncurrent_days = var.expire_noncurrent_objects_after
      }
    }
  }

  dynamic "rule" {
    for_each = var.transition_objects_after != null ? [1] : []

    content {
      id     = "TransitionObjects"
      status = "Enabled"

      filter {}

      transition {
        days          = var.transition_objects_after
        storage_class = var.transition_objects_to
      }

      noncurrent_version_transition {
        noncurrent_days = var.transition_noncurrent_objects_after
        storage_class   = var.transition_noncurrent_objects_to
      }
    }
  }

  dynamic "rule" {
    for_each = var.custom_lifecycle_rules

    content {
      id     = rule.key
      status = rule.value.enabled ? "Enabled" : "Disabled"

      dynamic "expiration" {
        for_each = rule.value.expiration != null ? [1] : []

        content {
          date = rule.value.expiration.date
          days = rule.value.expiration.days
        }
      }

      filter {
        object_size_greater_than = rule.value.filter.object_size_greater_than
        object_size_less_than    = rule.value.filter.object_size_less_than
        prefix                   = rule.value.filter.prefix

        dynamic "and" {
          for_each = rule.value.filter.and != null ? [1] : []

          content {
            object_size_greater_than = rule.value.filter.and.object_size_greater_than
            object_size_less_than    = rule.value.filter.and.object_size_less_than
            prefix                   = rule.value.filter.and.prefix
            tags                     = rule.value.filter.and.tags
          }
        }

        dynamic "tag" {
          for_each = rule.value.filter.tag != null ? [1] : []

          content {
            key   = rule.value.filter.tag.key
            value = rule.value.filter.tag.value
          }
        }
      }

      dynamic "noncurrent_version_expiration" {
        for_each = rule.value.noncurrent_version_expiration != null ? [1] : []

        content {
          newer_noncurrent_versions = rule.value.noncurrent_version_expiration.newer_noncurrent_versions
          noncurrent_days           = rule.value.noncurrent_version_expiration.noncurrent_days
        }
      }

      dynamic "noncurrent_version_transition" {
        for_each = rule.value.noncurrent_version_transition != null ? [1] : []

        content {
          newer_noncurrent_versions = rule.value.noncurrent_version_transition.newer_noncurrent_versions
          noncurrent_days           = rule.value.noncurrent_version_transition.noncurrent_days
          storage_class             = rule.value.noncurrent_version_transition.storage_class
        }
      }

      dynamic "transition" {
        for_each = rule.value.transition != null ? [1] : []

        content {
          date          = rule.value.transition.date
          days          = rule.value.transition.days
          storage_class = rule.value.transition.storage_class
        }
      }
    }
  }

  depends_on = [
    aws_s3_bucket_versioning.default,
  ]
}
