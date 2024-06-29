output "function_arn" {
  description = "The ARN of the Lambda Function"
  value       = aws_lambda_function.demo_lambda.arn
}

output "function_name" {
  description = "The ARN of the Lambda Function"
  value       = aws_lambda_function.demo_lambda.function_name
}
