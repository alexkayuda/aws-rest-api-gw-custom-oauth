output "name" {
  value = aws_api_gateway_rest_api.api-gw.name
}

output "id" {
  value = aws_api_gateway_rest_api.api-gw.id
}

output "arn" {
  value = aws_api_gateway_rest_api.api-gw.arn
}

output "execution_arn" {
  value = aws_api_gateway_rest_api.api-gw.execution_arn
}

output "api-resource-v1-test-id"{
  value = aws_api_gateway_resource.api-resource-v1-test.id
}