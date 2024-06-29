########## LAMBDA FUNCTION CODE #################
resource "aws_lambda_function" "demo_lambda" {
  # If the file is not in the current working directory you will need to include a
  # path.module in the filename.
  filename      = var.filename
  function_name = var.function_name
  role          = aws_iam_role.demo_lambda.arn
  handler       = var.handler

  source_code_hash = data.archive_file.lambda.output_base64sha256

  runtime = var.runtime

  environment {
    variables = {
      env = "dev"
    }
  }
}
