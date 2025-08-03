################################################################################
# # Method settings
# resource "aws_api_gateway_method_settings" "method_settings" {

#   # depends_on = [ aws_api_gateway_stage.dev-stage ]

#   rest_api_id = aws_api_gateway_rest_api.api-gw.id
#   stage_name  = aws_api_gateway_stage.dev-stage.stage_name
#   method_path = "*/*"
#   settings {
#     logging_level      = "INFO"
#     data_trace_enabled = true
#     metrics_enabled    = true
#   }
# }

################################################################################

# GET method for the path "/v1/test"
resource "aws_api_gateway_method" "api-method-v1-test-GET" {
  rest_api_id   = aws_api_gateway_rest_api.api-gw.id
  resource_id   = aws_api_gateway_resource.api-resource-v1-test.id
  http_method   = "GET"
  authorization = "NONE"
  # authorization = "CUSTOM"
  # authorizer_id = aws_api_gateway_authorizer.my_authorizer.id
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

  # response_parameters = {
  #   "method.response.header.Access-Control-Allow-Headers"     = true,
  #   "method.response.header.Access-Control-Allow-Methods"     = true,
  #   "method.response.header.Access-Control-Allow-Origin"      = true,
  #   "method.response.header.Access-Control-Allow-Credentials" = true
  # }
}

# resource "aws_api_gateway_method" "methods" {
#   for_each = {
#     for route in var.routes : "${route.method} ${join("/", route.path_parts)}" => route
#   }

#   rest_api_id   = aws_api_gateway_rest_api.this.id
#   resource_id   = aws_api_gateway_resource.resources[join("/", each.value.path_parts)].id
#   http_method   = upper(each.value.method)
#   authorization = upper(each.value.authorization_type)

#   dynamic "authorizer_id" {
#     for_each = each.value.authorization_type == "CUSTOM" ? [1] : []
#     content {
#       authorizer_id = each.value.authorizer_id
#     }
#   }
# }

