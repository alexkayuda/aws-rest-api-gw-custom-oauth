# # Setup Lambda permission to allow API Gateway to invoke the Lambda function
# resource "aws_lambda_permission" "api_gateway" {

#   # Only attach to API GW if api_gateway_execution_arn is provided
#   # count = var.api_gateway_execution_arn != "" ? 1 : 0

#   statement_id  = "AllowAPIGatewayInvoke"
#   action        = "lambda:InvokeFunction"
#   function_name = aws_lambda_function.lambda-function.function_name
#   principal     = "apigateway.amazonaws.com"
#   source_arn    = "${var.api_gateway_execution_arn}/*/*"
# }