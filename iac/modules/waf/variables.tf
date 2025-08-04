variable "name" {
  description = "WAF name"
  type        = string
}

variable "description" {
  description = "Description for the WAF Web ACL"
  type        = string
  default     = "WAF for API Gateway with Core Rule Set"
}

variable "enable_rate_limit" {
  description = "Whether to enable IP rate limiting"
  type        = bool
  default     = false
}

variable "rate_limit" {
  description = "Rate limit threshold (requests per 5 minutes)"
  type        = number
  default     = 1000
}

