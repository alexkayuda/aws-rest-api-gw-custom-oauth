# Deployment of the API Gateway
resource "aws_api_gateway_deployment" "deployment" {

  rest_api_id = aws_api_gateway_rest_api.api-gw.id

#   depends_on = [
#     aws_api_gateway_integration.api-method-v1-test-GET-lambda-integration
#   ]

  triggers = {
    redeployment = sha1(jsonencode([
      # resources
      aws_api_gateway_resource.api-resource-v1,
      aws_api_gateway_resource.api-resource-v1-test,
      
      # methods
      aws_api_gateway_method.api-method-v1-test-GET,

      # integration
      aws_api_gateway_integration.api-method-v1-test-GET-lambda-integration
    ]))
  }

  lifecycle {
    create_before_destroy = true
  }
}

# Create a stage for the API Gateway
resource "aws_api_gateway_stage" "dev-stage" {

    depends_on = [ 
        aws_api_gateway_account.account_settings,
        aws_cloudwatch_log_group.api_gateway_execution_logs 
    ]

    stage_name    = "${var.env}-stage"
    rest_api_id   = aws_api_gateway_rest_api.api-gw.id
    deployment_id = aws_api_gateway_deployment.deployment.id

  access_log_settings {
    destination_arn = aws_cloudwatch_log_group.api_gateway_execution_logs.arn
    format = jsonencode({
      requestId       = "$context.requestId",
      ip              = "$context.identity.sourceIp",
      caller          = "$context.identity.caller",
      user            = "$context.identity.user",
      requestTime     = "$context.requestTime",
      httpMethod      = "$context.httpMethod",
      resourcePath    = "$context.resourcePath",
      status          = "$context.status",
      protocol        = "$context.protocol",
      responseLength  = "$context.responseLength"
    })
  }
}

# # Method settings
resource "aws_api_gateway_method_settings" "method_settings" {

  rest_api_id = aws_api_gateway_rest_api.api-gw.id
  stage_name  = aws_api_gateway_stage.dev-stage.stage_name
  method_path = "*/*"
  settings {
    logging_level      = "INFO"
    data_trace_enabled = true
    metrics_enabled    = true
  }

}