output "bucket_id" {
  description = "The S3 bucket ID"
  value       = aws_s3_bucket.demo_bucket.id
}

output "bucket_name" {
  description = "The S3 bucket name"
  value       = aws_s3_bucket.demo_bucket.arn
}