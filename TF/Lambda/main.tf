########## LAMBDA FUNCTION CODE #################
resource "aws_lambda_function" "demo_lambda" {
  
  filename      = var.filename
  function_name = var.function_name
  role          = var.role
  handler       = var.handler

  source_code_hash = var.source_code_hash

  runtime = var.runtime

  environment {
    variables = var.environment_variables
  }
}
