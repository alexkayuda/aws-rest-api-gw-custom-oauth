resource "aws_api_gateway_rest_api" "api-gw" {
  # name = "dev-api-gw"
  name        = "${var.env}-${var.name}" # E.g. dev-api-gw
  description = "REST API Gateway"

  endpoint_configuration {
    types = ["REGIONAL"]
  }
}