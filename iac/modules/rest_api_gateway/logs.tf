# Allow GW to Push Logs to CloudWatch
resource "aws_iam_role" "api_gw_cloudwatch_role" {
  name = "api_gw-cloudwatch-${var.env}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement: [{
      Effect    = "Allow",
      Principal = { Service = "apigateway.amazonaws.com" },
      Action    = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "api_gw_cloudwatch_attach" {
    role       = aws_iam_role.api_gw_cloudwatch_role.name
    policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonAPIGatewayPushToCloudWatchLogs"
    # policy_arn = "arn:${data.aws_partition.current.partition}:iam::aws:policy/service-role/AmazonAPIGatewayPushToCloudWatchLogs"
}

resource "aws_api_gateway_account" "account_settings" {
    cloudwatch_role_arn = aws_iam_role.api_gw_cloudwatch_role.arn
}

# CloudWatch log group for api execution logs
resource "aws_cloudwatch_log_group" "api_gateway_execution_logs" {
  name              = "API-Gateway-Execution-Logs/${aws_api_gateway_rest_api.api-gw.name}"
  retention_in_days = 7
}