# --------------
# ELB
# --------------
resource "aws_lb" "main" {
  name               = "aws-study-elb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.elb.id]
  subnets = [
    aws_subnet.public_a.id,
    aws_subnet.public_c.id,
  ]

  tags = {
    Name = "aws-study-elb"
  }
}

# ---------------
# Target Group
# ---------------
resource "aws_lb_target_group" "main" {
  protocol = "HTTP"
  port     = 8080
  vpc_id   = aws_vpc.main.id

  health_check {
    protocol            = "HTTP"
    path                = "/"
    port                = "traffic-port"
    interval            = 10
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
    matcher             = "200"
  }

  tags = {
    Name = "aws-study-elb-target-group"
  }
}

# ---------------
# Target Group Attachment
# ---------------
resource "aws_lb_target_group_attachment" "main" {
  target_group_arn = aws_lb_target_group.main.id
  target_id        = aws_instance.main.id
  port             = 8080
}

# ---------------
# ELB Listener
# ---------------
resource "aws_lb_listener" "main" {
  load_balancer_arn = aws_lb.main.id
  port              = 80
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.main.id
  }
}