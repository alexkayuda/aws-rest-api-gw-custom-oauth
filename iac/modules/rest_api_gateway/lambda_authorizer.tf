# resource "aws_api_gateway_authorizer" "oauth_lambda_authorizer" {
#   name                             = "oauth_lambda_authorizer"
#   rest_api_id                      = aws_api_gateway_rest_api.api-gw.id
#   authorizer_uri                   = "arn:aws:apigateway:${var.region}:lambda:path/2015-03-31/functions/${aws_lambda_function.lambda_authorizer.arn}/invocations"
#   identity_source                  = "method.request.header.Authorization" # or authrorizationToken
#   authorizer_result_ttl_in_seconds = 0
# }

# ################################################################################
# # Lambda IAM role to assume the role
# ################################################################################
# resource "aws_iam_role" "lambda_authorizer_role" {
#   name = "lambda_auth_execution_role"
#   assume_role_policy = jsonencode({
#     "Version" : "2012-10-17",
#     "Statement" : [{
#       "Effect" : "Allow",
#       "Principal" : {
#         "Service" : "lambda.amazonaws.com"
#       },
#       "Action" : "sts:AssumeRole"
#     }]
#   })
# }

# ################################################################################
# # Assign policy to the role
# ################################################################################
# resource "aws_iam_policy_attachment" "lambda_basic_execution_authorizer" {
#   name       = "lambda_basic_execution_authorizer"
#   roles      = [aws_iam_role.lambda_authorizer_role.name]
#   policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
# }

# ################################################################################
# # Compressing lambda authorizer code
# ################################################################################
# data "archive_file" "lambda_authorizer_archive" {
#   type        = "zip"
#   source_dir  = "${path.module}/lambda_authorizer"
#   output_path = "${path.module}/lambda_authorizer.zip"
# }

# ################################################################################
# # Creating Lambda authorizer
# ################################################################################
# resource "aws_lambda_function" "lambda_authorizer" {
#   function_name = "LambdaAuthorizer"
#   filename      = "${path.module}/lambda_authorizer.zip"

#   runtime     = "python3.12"
#   handler     = "lambda_authorizer.lambda_handler"
#   memory_size = 128
#   timeout     = 10

#   source_code_hash = data.archive_file.lambda_authorizer_archive.output_base64sha256

#   role = aws_iam_role.lambda_authorizer_role.arn

#   environment {
#     variables = {
#       JWT_SECRET_KEY = "secret_api_tutorial"
#     }
#   }
# }

# ################################################################################
# # Creating CloudWatch Log group for Lambda Function
# ################################################################################
# resource "aws_cloudwatch_log_group" "book_lambda_authorizer_cloudwatch" {
#   name              = "/aws/lambda/${aws_lambda_function.lambda_authorizer.function_name}"
#   retention_in_days = 7
# }