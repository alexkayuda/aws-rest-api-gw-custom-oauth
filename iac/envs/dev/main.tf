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

################################################################################################

# Creating Rest API GateWay
module "rest_api_gw" {
  source = "../../modules/rest_api_gateway"
  env    = var.environment
  name   = "rest-oauth-api-gw-${var.environment}"
  region = var.region
  stage  = var.region
}

# Creating WAF
module "waf_for_rest_apt_gw" {
  source            = "../../modules/waf"
  name              = "api-core-waf"
  enable_rate_limit = false
  # rate_limit        = 1000
}

# Associate WAF with API GW's Stage
resource "aws_wafv2_web_acl_association" "rest_api_waf" {
  resource_arn = "arn:aws:apigateway:${var.region}::/restapis/${module.rest_api_gw.id}/stages/${module.rest_api_gw.stage_name}"
  web_acl_arn  = module.waf_for_rest_apt_gw.web_acl_arn
}

# Creating Custom Authorizer Lambda
module "lambda_authorizer" {
  source   = "../../modules/lambda"
  name     = "custom-authorizer"
  runtime  = "provided.al2"
  handler  = "bootstrap"
  filename = "${path.module}/../../../lambdas/custom-authorizer-lambda/custom-authorizer-lambda.zip"
  # source_code_hash   = filebase64sha256("build/authorizer.zip")
}

# Creating TEST Lambda Backend
module "lambda_test" {
  source   = "../../modules/lambda"
  name     = "test-lambda"
  runtime  = "provided.al2"
  handler  = "bootstrap"
  filename = "${path.module}/../../../lambdas/test-lambda/test-lambda.zip" # needs to be an S3 bucket OR ignore and deploy via GitHub Actions

  # Allow Lambda to modify VPC & Subnets
  attach_vpc_policy = true

  # Adds API GW as a trigger
  # api_gateway_execution_arn = module.rest_api_gw.execution_arn
}

# Binding Lambda Authorizer with Rest API GW
module "authorizer" {
  depends_on = [module.rest_api_gw, module.lambda_authorizer]

  source            = "../../modules/rest_api_gateway_authorizer"
  name              = "CustomAuth"
  rest_api_id       = module.rest_api_gw.id
  execution_arn     = module.rest_api_gw.execution_arn
  lambda_invoke_arn = module.lambda_authorizer.invoke_arn
  lambda_name       = module.lambda_authorizer.name
}

# Allowing API Gateway to invoke the TEST Lambda function
resource "aws_lambda_permission" "lambda_test_api_gateway_trigger" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  principal     = "apigateway.amazonaws.com"
  function_name = module.lambda_test.name
  source_arn    = "${module.rest_api_gw.execution_arn}/*/*"
}

# Allowing API Gateway to invoke the Authorizer Lambda function
resource "aws_lambda_permission" "lambda_authorizer_api_gateway_trigger" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  principal     = "apigateway.amazonaws.com"
  function_name = module.lambda_authorizer.name
  source_arn    = "${module.rest_api_gw.execution_arn}/*/*"
}

