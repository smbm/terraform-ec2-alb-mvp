output "application_endpoint" {
  value = aws_lb.ec2_cluster_alb.dns_name
}