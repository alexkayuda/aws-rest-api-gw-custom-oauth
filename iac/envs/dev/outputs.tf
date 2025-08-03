output "api_endpoint" {
  value = "https://${module.rest_api_gw.id}.execute-api.${var.region}.amazonaws.com/${var.environment}"
}