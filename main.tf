terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region = var.region
}

data "aws_availability_zones" "available" {
  state = "available"
}

# # This may be a mistake as my EC2 instances will clobber themselves when a new image comes out
# # Useful for if you always want the latest and greatest though
# data "aws_ami" "ubuntu" {
#   owners = ["099720109477"]

#   most_recent = true

#   filter {
#     name = "name"
#     values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server*"]
#   }
# }
