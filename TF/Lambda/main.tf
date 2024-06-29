########## LAMBDA FUNCTION CODE #################
resource "aws_lambda_function" "demo_lambda" {
  # If the file is not in the current working directory you will need to include a
  # path.module in the filename.
  filename      = var.filename
  function_name = var.function_name
  role          = var.role
  handler       = var.handler

  source_code_hash = var.source_code_hash

  runtime = var.runtime

  environment {
    variables = {
      env = "dev"
    }
  }
}
