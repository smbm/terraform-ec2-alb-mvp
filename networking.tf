resource "aws_vpc" "ec2_cluster_vpc" {
  cidr_block = "10.42.0.0/16"
}

resource "aws_subnet" "ec2_cluster_public_subnet" {
  count = var.number_of_public_subnets

  availability_zone = data.aws_availability_zones.available.names[count.index]
  cidr_block = "10.42.${count.index + 1}.0/24"

  map_public_ip_on_launch = true

  vpc_id = aws_vpc.ec2_cluster_vpc.id
}

resource "aws_subnet" "ec2_cluster_private_subnet" {
  count = var.number_of_private_subnets

  availability_zone = data.aws_availability_zones.available.names[count.index]
  cidr_block = "10.42.${count.index + 11}.0/24"

  vpc_id = aws_vpc.ec2_cluster_vpc.id
}

resource "aws_security_group" "ec2_cluster_sg" {
  name = "ec2_cluster_sg"
  description = "Allow HTTP"
  vpc_id = aws_vpc.ec2_cluster_vpc.id

  ingress {
    description = "HTTP"
    from_port = 80
    to_port = 80
    protocol = "tcp"
    # cidr_blocks = ["0.0.0.0/0"] # Maybe remove this line for debugging
    security_groups = [aws_security_group.alb_sg.id]
  }

  # # Maybe remove this section for debugging
  # ingress {
  #   description = "SSH"
  #   from_port = 22
  #   to_port = 22
  #   protocol = "tcp"
  #   cidr_blocks = ["0.0.0.0/0"]
  # }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "alb_sg" {
  name = "alb_sg"
  description = "Allow HTTP"
  vpc_id = aws_vpc.ec2_cluster_vpc.id

  ingress {
    description = "HTTP"
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 80
    to_port = 80
    protocol = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_internet_gateway" "ec2_cluster_igw" {
  vpc_id = aws_vpc.ec2_cluster_vpc.id
}

resource "aws_route_table" "ec2_cluster_rt" {
  vpc_id = aws_vpc.ec2_cluster_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.ec2_cluster_igw.id
  }
}

resource "aws_default_route_table" "ec2_cluster_private_rt" {
  default_route_table_id = aws_vpc.ec2_cluster_vpc.default_route_table_id
}

resource "aws_route_table_association" "ec2_cluster_pub_subnet_assoc" {
  count = var.number_of_public_subnets
  subnet_id = aws_subnet.ec2_cluster_public_subnet.*.id[count.index]
  route_table_id = aws_route_table.ec2_cluster_rt.id
}

resource "aws_route_table_association" "ec2_cluster_priv_subnet_assoc" {
  count = var.number_of_private_subnets
  subnet_id = aws_subnet.ec2_cluster_private_subnet.*.id[count.index]
  route_table_id = aws_default_route_table.ec2_cluster_private_rt.id
}