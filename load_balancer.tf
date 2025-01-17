resource "aws_security_group" "lb" {
  name   = format("%s-load-balancer", var.project_name)
  vpc_id = data.aws_ssm_parameter.vpc.value
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
resource "aws_security_group_rule" "ingress_80" {
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 80
  to_port           = 80
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.lb.id
  description       = "Allow HTTP traffic"

}
resource "aws_security_group_rule" "ingress_443" {
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 443
  to_port           = 443
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.lb.id
  description       = "Allow HTTPS traffic"

}

resource "aws_lb" "main" {
  name               = format("%s-ingress", var.project_name)
  internal           = var.load_balancer_internal
  load_balancer_type = var.load_balancer_type
  subnets = [
    data.aws_ssm_parameter.subnet_public_1a.value,
    data.aws_ssm_parameter.subnet_public_1b.value,
    data.aws_ssm_parameter.subnet_public_1c.value
  ]
  security_groups                  = [aws_security_group.lb.id]
  enable_cross_zone_load_balancing = false
  enable_deletion_protection       = false
}

resource "aws_lb_listener" "main" {
  load_balancer_arn = aws_lb.main.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"
    fixed_response {
      content_type = "text/plain"
      status_code  = "200"
      message_body = "Page not found"
    }


  }
}