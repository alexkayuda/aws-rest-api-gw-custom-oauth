resource "aws_lambda_function" "lambda-function" {
  function_name = var.name
  handler       = var.handler
  runtime       = var.runtime
  role          = aws_iam_role.lambda_execution_role.arn
  filename      = var.s3_package_path != null ? null : var.filename
  s3_bucket     = var.s3_package_path != null ? var.s3_bucket : null
  s3_key        = var.s3_package_path != null ? var.s3_package_path : null
  timeout       = var.timeout
  memory_size   = var.memory_size
  architectures = var.architectures

  environment {
    variables = var.environment_variables
  }

  tracing_config {
    mode = "Active"
  }

  vpc_config {
    subnet_ids         = var.subnet_ids
    security_group_ids = var.security_group_ids
  }

  kms_key_arn = var.kms_key_arn

  layers = var.layers

  tags = var.tags
}
