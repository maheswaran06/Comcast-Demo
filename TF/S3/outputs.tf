output "bucket_id" {
  description = "The ARN of the IAM role"
  value       = aws_iam_role.aws_s3_bucket.id
}