resource "aws_api_gateway_rest_api" "api-gw" {
  name        = "${var.name}"
  description = "REST API Gateway"

  endpoint_configuration {
    types = ["REGIONAL"]
  }
}