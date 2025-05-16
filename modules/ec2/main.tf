resource "aws_security_group" "this" {
  name        = "${var.environment}-ec2-private-sg-${var.product_name}"
  description = "Allow SSH only from Bastion or Admin IP"
  vpc_id      = var.vpc_id

  ingress {
    description = "SSH from allowed IP"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.allowed_ssh_cidr]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.environment}-ec2-private-sg-${var.product_name}"
  }
}

resource "aws_instance" "this" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = var.private_subnet_id
  vpc_security_group_ids = [aws_security_group.this.id]
  iam_instance_profile   = var.instance_profile_name

  root_block_device {
    encrypted = true
    volume_size = var.volume_size
    delete_on_termination = true
    volume_type = "gp3"
  }

  tags = {
    Name = "${var.environment}-private-ec2-instance-${var.product_name}"
  }
}
