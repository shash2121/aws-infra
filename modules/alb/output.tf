output "lb_arn" {
  value = aws_lb.alb.arn
}

output "lb_id" {
  value = aws_lb.alb.id
}

output "lb_dns" {
  value = aws_lb.alb.dns_name
}

output "lb_zone_id" {
  value = aws_lb.alb.zone_id
}