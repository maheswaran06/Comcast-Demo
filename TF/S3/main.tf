########## S3 CODE #################
resource "aws_s3_bucket" "demo_bucket" {

  bucket = var.bucket_name
  tags   = var.tags

}