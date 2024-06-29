resource "aws_s3_bucket" "oidctest" {
  bucket = "test-bucket-comcast-demo-purpose"

  tags = {
    Name        = "test-bucket-comcast-demo-purpose"
    Environment = "Dev"
  }
}

########## IAM POLICY ############
data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

######### IAM ROLE ##############
resource "aws_iam_role" "demo_lambda" {
  name               = "Comcast-Demo-lambda-policy"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

data "archive_file" "lambda" {
  type        = "zip"
  source_file = "../Lambda"
  output_path = "lambda_function_payload.zip"
}


########## LAMBDA FUNCTION CODE #################
resource "aws_lambda_function" "demo_lambda" {
  # If the file is not in the current working directory you will need to include a
  # path.module in the filename.
  filename      = "lambda_function_payload.zip"
  function_name = "Comcast-Demo-lambda-function"
  role          = aws_iam_role.demo_lambda.arn
  handler       = "index.test"

  source_code_hash = data.archive_file.lambda.output_base64sha256

  runtime = "python3.12"

  environment {
    variables = {
      env = "dev"
    }
  }
}
