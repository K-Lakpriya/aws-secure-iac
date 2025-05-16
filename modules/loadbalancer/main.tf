resource "aws_lb" "this" {
  name               = "${var.environment}-alb-${var.product_name}"
  internal           = false
  load_balancer_type = "application"
  security_groups    = []
  subnets            = var.public_subnet_ids

  tags = {
    Name = "${var.environment}-alb-${var.product_name}"
  }
}

resource "aws_lb_target_group" "this" {
  name     = "${var.environment}-tg-${var.product_name}"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    path                = "/"
    protocol            = "HTTP"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  tags = {
    Name = "${var.environment}-tg-${var.product_name}"
  }
}

resource "aws_lb_listener" "this" {
  load_balancer_arn = aws_lb.this.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this.arn
  }
}

resource "aws_lb_target_group_attachment" "this" {
  target_group_arn = aws_lb_target_group.this.arn
  target_id        = var.target_instance_id
  port             = 80
}