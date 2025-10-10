output "id" {
  value       = aws_s3_bucket.default.id
  description = "The ID of the S3 bucket."
}
output "name" {
  value       = aws_s3_bucket.default.bucket
  description = "The name of the S3 bucket."
}
output "arn" {
  value       = aws_s3_bucket.default.arn
  description = "The ARN of the S3 bucket."
}
