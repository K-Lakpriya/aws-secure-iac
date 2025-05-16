# IAM Role for EC2 (Least Privilege)
resource "aws_iam_role" "ec2_role" {
  name = "ec2-basic-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })

  tags = {
    Name = "${var.environment}-ec2-basic-role-${var.product_name}"
  }
}

# IAM Policy Attachment: Allow EC2 to use SSM (for remote management)
resource "aws_iam_role_policy_attachment" "ssm" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

# IAM Instance Profile (so we can attach the role to the EC2)
resource "aws_iam_instance_profile" "this" {
  name = "${var.environment}-ec2-instance-profile-${var.product_name}"
  role = aws_iam_role.ec2_role.name
}
