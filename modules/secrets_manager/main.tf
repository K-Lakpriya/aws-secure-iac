resource "aws_secretsmanager_secret" "example" {
  name        = "${var.environment}-example-secret-${var.product_name}"
  description = "Managed by Terraform"
}

resource "aws_secretsmanager_secret_version" "example" {
  secret_id     = aws_secretsmanager_secret.example.id
  secret_string = jsonencode(var.secret_values)
}

output "secret_arn" {
  value = aws_secretsmanager_secret.example.arn
}
