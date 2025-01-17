output "load_balancer_dns" {
  value = aws_lb.main.dns_name
}

output "lb_ssn_arn" {
  value = aws_ssm_parameter.lb_arn.id
}

output "lb_ssn_listener" {
  value = aws_ssm_parameter.lb_listener.id
}
