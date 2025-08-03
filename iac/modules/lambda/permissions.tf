# Setup Lambda permission to allow API Gateway to invoke the Lambda function
resource "aws_lambda_permission" "api_gateway" {
  # count      = var.allow_api_gateway_to_trigger ? 1 : 0
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.my-lambda-function.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${var.allow_api_gateway_to_trigger}/*/*"
}

# # Setup Lambda permission to allow API Gateway to invoke the Lambda function
# ################################################################################
# resource "aws_lambda_permission" "allow_api_gateway_invoke_authorizer" {
#   statement_id  = "AllowAPIGatewayInvoke_authorizer"
#   action        = "lambda:InvokeFunction"
#   function_name = aws_lambda_function.lambda_authorizer.function_name
#   principal     = "apigateway.amazonaws.com"
#   source_arn    = "${var.api_gateway_execution_arn}/*/*"
# }