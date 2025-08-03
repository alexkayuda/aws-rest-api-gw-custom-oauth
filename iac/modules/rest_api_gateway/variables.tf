variable "env" {
  type    = string
}

variable "name" {
  type    = string
  default = "default-name"
}

variable "region" {
  type    = string
}

variable "stage" {
  type = string
  description = "name of the stage"
}

# variable "routes" {
#   type = list(object({
#     path_parts         = list(string)
#     method             = string
#     lambda_name        = string
#     lambda_invoke_arn  = string
#     authorization_type = string        # "CUSTOM", "NONE", "AWS_IAM"
#     authorizer_id      = optional(string)
#   }))
# }