output "instance_id" {
  description = "The ID of the created EC2 instance"
  value       = aws_instance.this.id
}

output "instance_private_ip" {
  description = "The private IP of the created EC2 instance"
  value       = aws_instance.this.private_ip
}

output "security_group_id" {
  description = "Security Group ID created for the EC2"
  value       = aws_security_group.this.id
}
