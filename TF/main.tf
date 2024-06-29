#### IAM POLICY ####

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

#### IAM ROLE ###

module "comcast_iam_role" {
  source    = "./Resources/"
  name               = "Comcast-Demo-lambda-policy"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

#### LAMBDA CODE ###

data "archive_file" "lambda" {
  type        = "zip"
  source_file = "../Lambda/lambda.py"
  output_path = "lambda_function_payload.zip"
}

### LAMBDA FUNCTION ###

module "comcast_lambda_function" {
  source        = "./Resources/"
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