resource "aws_api_gateway_authorizer" "custom-authorizer" {
  name                             = var.name
  rest_api_id                      = var.rest_api_id
  authorizer_uri                   = var.lambda_invoke_arn
  authorizer_result_ttl_in_seconds = 3 # change to 300 in prod
  type                             = "TOKEN"
  identity_source                  = "method.request.header.Authorization"
}

resource "aws_lambda_permission" "auth" {
  statement_id  = "AllowInvokeAuth"
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${var.execution_arn}/*/*"
}
