resource "aws_ssm_parameter" "test"{
    name = "test"
    type = "String"
    value= "test1"
}

resource "aws_s3_bucket" "oidctest" {
  bucket = "my-tf-test-bucket"

  tags = {
    Name        = "test-bucket-comcast-demo-purpose"
    Environment = "Dev"
  }
}
