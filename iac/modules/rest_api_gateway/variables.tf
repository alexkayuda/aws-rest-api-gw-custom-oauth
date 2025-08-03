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