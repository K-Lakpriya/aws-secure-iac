variable "vpc_id" {
  description = "The VPC ID where EC2 is deployed"
  type        = string
}

variable "private_subnet_id" {
  description = "The private subnet ID for the EC2 instance"
  type        = string
}

variable "ami_id" {
  description = "AMI ID to use for the EC2 instance"
  type        = string
}

variable "instance_profile_name" {
  description = "IAM Instance Profile name for the EC2 instance"
  type        = string
}

variable "allowed_ssh_cidr" {
  description = "Allowed CIDR block for SSH access"
  type        = string
  default     = "0.0.0.0/0" # (⚡ Update this to your admin IP range later)
}

variable "instance_type" {
    description = "EC2 instance type"
    type        = string
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