variable "region" {
  description = "AWS region to deploy to"
  type        = string
  default     = "us-east-1"
}

variable "ami_id" {
  description = "AMI ID for EC2 instance"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "volume_size" {
  description = "Size of the root volume in GB"
  type        = number
  default     = 20  
}

variable "environment" {
  description = "Deployment environment (prod, staging, test, qa)"
  type        = string
  validation {
    condition     = contains(["prod", "staging", "test", "qa"], var.environment)
    error_message = "Environment must be one of: prod, staging, test, qa"
  }
}

variable "product_name" {
  description = "Name of the product or application"
  type        = string
}
