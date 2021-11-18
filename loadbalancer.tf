resource "aws_lb_target_group" "ec2_cluster_tg" {
  name = "ecsClusterTg"
  port = 80
  protocol = "HTTP"
  vpc_id = aws_vpc.ec2_cluster_vpc.id
}

resource "aws_lb_target_group_attachment" "ec2_cluster_tga" {
  count = var.number_of_ec2_instances
  target_group_arn = aws_lb_target_group.ec2_cluster_tg.arn
  target_id = aws_instance.ec2_instances.*.id[count.index]
  port = 80
}

resource "aws_lb" "ec2_cluster_alb" {
  name = "ec2-cluster-alb"
  internal = false
  load_balancer_type = "application"
  security_groups = [aws_security_group.alb_sg.id]
  subnets = aws_subnet.ec2_cluster_public_subnet.*.id
}

resource "aws_lb_listener" "ec2_cluster_alb_listener" {
  load_balancer_arn = aws_lb.ec2_cluster_alb.arn
  port = "80"
  protocol = "HTTP"

  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.ec2_cluster_tg.arn
  }
}