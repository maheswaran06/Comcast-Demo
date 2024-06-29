output "bucket_id" {
  description = "The ARN of the IAM role"
  value       = aws_s3_bucket.demo_bucket.id
}