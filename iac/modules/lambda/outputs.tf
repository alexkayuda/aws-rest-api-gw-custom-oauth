output "name" {
  value = aws_lambda_function.lambda-function.function_name
}

output "arn" {
  value = aws_lambda_function.lambda-function.arn
}

output "invoke_arn" {
  value = aws_lambda_function.lambda-function.invoke_arn
}
