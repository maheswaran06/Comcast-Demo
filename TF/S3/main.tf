########## S3 CODE #################
resource "aws_s3_bucket" "example" {

  bucket = var.bucket_name
  tags   = var.tags

}