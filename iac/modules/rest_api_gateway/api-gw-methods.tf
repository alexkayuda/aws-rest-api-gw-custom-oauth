# GET method for the path "/v1/test"
resource "aws_api_gateway_method" "api-method-v1-test-GET" {
  rest_api_id   = aws_api_gateway_rest_api.api-gw.id
  resource_id   = aws_api_gateway_resource.api-resource-v1-test.id
  http_method   = "GET"
  # authorization = "NONE"
  authorization = "CUSTOM"
  authorizer_id = aws_api_gateway_authorizer.my_authorizer.id
}

resource "aws_api_gateway_integration" "api-method-v1-test-GET-lambda-integration" {
  rest_api_id             = aws_api_gateway_rest_api.api-gw.id
  resource_id             = aws_api_gateway_resource.api-resource-v1-test.id
  http_method             = aws_api_gateway_method.api-method-v1-test-GET.http_method
  type                    = "AWS_PROXY"
  integration_http_method = "POST" # MUST BE POST IF AWS_PROXY
  uri                     = "arn:aws:apigateway:us-east-1:lambda:path/2015-03-31/functions/arn:aws:lambda:us-east-1:237115040688:function:test-lambda/invocations"

  # uri                     = aws_lambda_function.book_lambda_function.invoke_arn
  # uri                     = module.test-lambda.lambda_function_arn
  # uri                     = "arn:aws:lambda:us-east-1:237115040688:function:test-lambda/"
}

resource "aws_api_gateway_method_response" "api-method-v1-test-GET-response-200" {
  rest_api_id = aws_api_gateway_rest_api.api-gw.id
  resource_id = aws_api_gateway_resource.api-resource-v1-test.id
  http_method = aws_api_gateway_method.api-method-v1-test-GET.http_method
  status_code = "200"
}
