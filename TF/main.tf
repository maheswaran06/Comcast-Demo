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
  source    = "./IAM_Role"
  name                = "Comcast-Demo-lambda-policy"
  assume_role_policy  = data.aws_iam_policy_document.assume_role.json
  managed_policy_arns = ["arn:aws:iam::aws:policy/AmazonS3FullAccess", "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole", "arn:aws:iam::aws:policy/AmazonSNSFullAccess"]
}

#### LAMBDA CODE ###

data "archive_file" "lambda" {
  type        = "zip"
  source_file = "../Lambda/lambda.py"
  output_path = "lambda_function_payload.zip"
}

### LAMBDA FUNCTION ###

module "comcast_lambda_function" {
  source        = "./Lambda"
  filename      = "lambda_function_payload.zip"
  function_name = "Comcast-Demo-lambda-function"
  role          = module.comcast_iam_role.role_arn
  handler       = "lambda.lambda_handler" 

  source_code_hash = data.archive_file.lambda.output_base64sha256

  runtime = "python3.12"
  environment_variables = {
    SOURCE_BUCKET       = "comcast-demo-bucket1",
    DESTINATION_BUCKET  = "comcast-demo-bucket2",
    SNS_TOPIC_ARN       = "arn:aws:sns:us-east-1:992382808270:comcast-demo-sns"

  }  
}

### S3 DEPLOYMENT ###

module "s3-1" {
  source    = "./S3"
  tags      = { 
    environment = "Prod" 
    }
  bucket_name = "comcast-demo-bucket1"
}

module "s3-2" {
  source    = "./S3"
  tags      = { 
    environment = "Prod" 
    }
  bucket_name = "comcast-demo-bucket2"
}


### BUCKET NOTIFICATION FOR S3-1 ###

resource "aws_lambda_permission" "allow_bucket" {
  statement_id  = "AllowExecutionFromS3Bucket"
  action        = "lambda:InvokeFunction"
  function_name = module.comcast_lambda_function.function_name
  principal     = "s3.amazonaws.com"
  source_arn    = module.s3-1.bucket_arn
}

resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket = module.s3-1.bucket_id

  lambda_function {
    lambda_function_arn = module.comcast_lambda_function.function_arn
    events              = ["s3:ObjectCreated:*"]
  }
  depends_on = [aws_lambda_permission.allow_bucket]
}


### SNS TOPIC ###

resource "aws_sns_topic" "topic" {
  name = "comcast-demo-sns"
}

resource "aws_sns_topic_subscription" "email-target" {
  topic_arn = aws_sns_topic.topic.arn
  protocol  = "email"
  endpoint  = "gmaheswaran06@gmail.com"
}