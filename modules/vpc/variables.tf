variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  description = "CIDR block for public subnet"
  type        = string
  default     = "10.0.1.0/24"
}

variable "private_subnet_cidr" {
  description = "CIDR block for private subnet"
  type        = string
  default     = "10.0.2.0/24"
}
variable "vpc_name" {
  description = "Name of the VPC"
  type        = string
  default     = "my-vpc"
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