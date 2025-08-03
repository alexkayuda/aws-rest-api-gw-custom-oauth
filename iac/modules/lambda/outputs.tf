output "name" {
  value = aws_lambda_function.my-lambda-function.function_name
}

output "arn" {
  value = aws_lambda_function.my-lambda-function.arn
}

output "invoke_arn" {
  value = aws_lambda_function.my-lambda-function.invoke_arn
}

# output "lambda_role_arn" {
#   value = aws_iam_role.lambda_execution_role.arn
# }
