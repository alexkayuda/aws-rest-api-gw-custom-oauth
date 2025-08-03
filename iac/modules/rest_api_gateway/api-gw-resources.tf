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


# resource "aws_api_gateway_resource" "resources" {
#   for_each = {
#     for route in var.routes : join("/", route.path_parts) => {
#       parent_path_parts = slice(route.path_parts, 0, length(route.path_parts) - 1)
#       current_part      = route.path_parts[length(route.path_parts) - 1]
#     }
#   }

#   rest_api_id = aws_api_gateway_rest_api.this.id
#   path_part   = each.value.current_part
#   parent_id = length(each.value.parent_path_parts) == 0 ? aws_api_gateway_rest_api.this.root_resource_id : aws_api_gateway_resource.resources[join("/", each.value.parent_path_parts)].id
# }