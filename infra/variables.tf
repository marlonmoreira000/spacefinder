variable "aws_region" {
  description = "The AWS region we want to deploy our resources to"
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  type        = string
  default     = "dev"
  description = "The development environment"
}

