variable "region" {
  default = "eu-west-2"
}

variable "number_of_public_subnets" {
  default = 3
}

variable "number_of_private_subnets" {
  default = 3
}

variable "number_of_ec2_instances" {
  default = 3
}

variable "ec2_instance_type" {
  default = "t2.micro"
}

variable "ec2_ami" {
  default = "ami-0cbd3ff0171edf4c4"
}