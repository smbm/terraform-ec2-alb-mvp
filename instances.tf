resource "aws_instance" "ec2_instances" {
  count = var.number_of_ec2_instances

  ami = var.ec2_ami #data.aws_ami.ubuntu.id
  instance_type = var.ec2_instance_type
  subnet_id = aws_subnet.ec2_cluster_private_subnet.*.id[count.index]

  # Do something basic so as to have a demonstratable instance
  user_data = <<EOF
#!/bin/bash
sudo apt update
# Install NGINX
sudo apt install -y nginx
sudo sh -c "echo '<h1>Hello from EC2 instance ${count.index + 1}</h1>' > /var/www/html/index.html"
# Start NGINX
sudo systemctl start nginx
EOF

  vpc_security_group_ids = [aws_security_group.ec2_cluster_sg.id]

  # # Add your key if you need to SSH for debugging
  # key_name = "tomv-test"
}