resource "aws_s3_bucket" "plan_outputs" {
  bucket = "backstage-terraform-plan-outputs"

  force_destroy = true
}

resource "aws_s3_bucket_public_access_block" "plan_outputs" {
  bucket = aws_s3_bucket.plan_outputs.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_server_side_encryption_configuration" "plan_outputs" {
  bucket = aws_s3_bucket.plan_outputs.id

  rule {
    bucket_key_enabled = true

    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_versioning" "plan_outputs" {
  bucket = aws_s3_bucket.plan_outputs.id

  versioning_configuration {
    status = "Enabled"
  }
}
