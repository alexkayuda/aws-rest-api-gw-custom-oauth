terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = var.region
}

# module "rest_api_gw" {
#   source = "../../modules/rest_api_gateway"
#   name = "oauth-rest-api-gw"
#   env = var.environment
#   region = var.region
#   stage = var.environment 
#   routes = [
#     # {
#     #   path_parts         = ["v1", "backend-test"]
#     #   method             = "GET"
#     #   lambda_name        = module.lambda_backend.name
#     #   lambda_invoke_arn  = module.lambda_backend.invoke_arn
#     #   authorization_type = "CUSTOM"
#     #   authorizer_id      = module.auth_custom.authorizer_id
#     # },
#     {
#       path_parts         = ["v1", "test"]
#       method             = "POST"
#       lambda_name        = module.test-lambda.name
#       lambda_invoke_arn  = module.test-lambda.invoke_arn
#       authorization_type = "NONE"
#       # authorizer_id      = module.auth_custom.authorizer_id
#     }
#   ]
# }

module "api_gw" {
  source = "../../modules/rest_api_gateway"
  # depends_on = [module.test-lambda]
  env    = var.environment
  name   = "rest-api-gw-${var.environment}"
  region = var.region
  stage  = var.region
  # routes = [
  #   {
  #     path_parts         = ["v1", "test"]
  #     method             = "POST"
  #     lambda_name        = module.test-lambda.name
  #     lambda_invoke_arn  = module.test-lambda.invoke_arn
  #     authorization_type = "NONE"
  #     # authorizer_id      = module.auth_custom.authorizer_id
  #   }
  # ]
}

module "test-lambda" {
  source = "../../modules/lambda"

  name = "test-lambda"
  runtime       = "provided.al2"
  handler       = "bootstrap"
  filename      = "${path.module}/../../../lambdas/test-lambda/test-lambda.zip" # needs to be an S3 bucket OR ignore and deploy via GitHub Actions

  attach_vpc_policy         = true
  api_gateway_execution_arn = module.api_gw.execution_arn

  allow_api_gateway_to_trigger = module.api_gw.execution_arn
  
  environment_variables = {
    SECRETS_MANAGER_RDS_CREDS = "ARN OF Secrets Manager RDS Creds"
    LOG_LEVEL                 = "INFO"
  }
  tags = {
    APP   = "OAuth API GW"
    OWNER = "platform"
    ENV   = "dev"
  }
}


# module "authorizer" {
#   source            = "./modules/api_gateway_authorizer"
#   name              = "CustomAuth"
#   rest_api_id       = module.api_gw.id
#   lambda_invoke_arn = module.lambda_authorizer.invoke_arn
#   lambda_name       = module.lambda_authorizer.name
#   execution_arn     = module.api_gw.execution_arn
# }