variable "environment" {
  description = "Deployment environment (prod, staging, test, qa)"
  type        = string
}

variable "product_name" {
  description = "Name of the product or application"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "public_subnet_ids" {
  description = "List of public subnet IDs"
  type        = list(string)
}

variable "target_instance_id" {
  description = "EC2 instance ID to register in target group"
  type        = string
}