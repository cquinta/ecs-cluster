resource "aws_ssm_parameter" "lb_arn" {
  name  = format("/%s/ecs/lb/id", var.project_name)
  value = aws_lb.main.arn
  type  = "String"
}

resource "aws_ssm_parameter" "lb_listener" {
  name  = format("/%s/ecs/lb/listener", var.project_name)
  value = aws_lb_listener.main.arn
  type  = "String"
}