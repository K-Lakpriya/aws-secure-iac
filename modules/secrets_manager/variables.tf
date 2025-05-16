# variable "secret_name" {
#   description = "Name of the secret"
#   type        = string
#   default     = "example-secret"
# }

variable "secret_values" {
  description = "Key-value map to store in Secrets Manager"
  type        = map(string)
  default = {
    username = "admin"
    password = "CHANGEME-PLEASE"
  }
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
