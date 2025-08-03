variable "name" {
  description = "Name of the Lambda function"
  type        = string
}

variable "handler" {
  description = "Function entrypoint"
  type        = string
}

variable "runtime" {
  description = "Lambda runtime"
  type        = string
  default     = "provided.al2"
}

variable "filename" {
  description = "Local path to Lambda deployment package"
  type        = string
  default     = null
}

variable "s3_bucket" {
  description = "S3 bucket containing Lambda code"
  type        = string
  default     = null
}

variable "s3_package_path" {
  description = "Path to Lambda code in S3"
  type        = string
  default     = null
}

variable "timeout" {
  description = "Lambda timeout in seconds"
  type        = number
  default     = 10
}

variable "memory_size" {
  description = "Memory in MB"
  type        = number
  default     = 128
}

variable "architectures" {
  description = "CPU architectures (e.g. x86_64 or arm64)"
  type        = list(string)
  default     = ["arm64"]
}

variable "subnet_ids" {
  description = "List of VPC subnet IDs"
  type        = list(string)
  default     = []
}

variable "security_group_ids" {
  description = "List of VPC security group IDs"
  type        = list(string)
  default     = []
}

variable "environment_variables" {
  description = "Environment variables map"
  type        = map(string)
  default     = {}
}

variable "layers" {
  description = "List of Lambda layer ARNs"
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "Tags to apply"
  type        = map(string)
  default     = {}
}

variable "kms_key_arn" {
  description = "KMS Key ARN for environment variable encryption"
  type        = string
  default     = null
}

variable "attach_vpc_policy" {
  description = "Attach VPC policy for Lambda (e.g. allow Lambda to modify VPC like creating ENIs)"
  type        = bool
  default     = false
}

# variable "api_gateway_execution_arn" {
#   type = string
#   default = ""
# }
