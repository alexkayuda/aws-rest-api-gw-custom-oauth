# API Resource for the path "/v1"
resource "aws_api_gateway_resource" "api-resource-v1" {
  rest_api_id = aws_api_gateway_rest_api.api-gw.id
  parent_id   = aws_api_gateway_rest_api.api-gw.root_resource_id
  path_part   = "v1"
}


# API Resource for the path "/v1/test"
resource "aws_api_gateway_resource" "api-resource-v1-test" {
  rest_api_id = aws_api_gateway_rest_api.api-gw.id
  parent_id   = aws_api_gateway_resource.api-resource-v1.id
  path_part   = "test"
}