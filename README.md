#Terraform ALB -> EC2 (MVP)
A small Terraform project to deploy EC2 instances behind an ALB at MVP level.

To get started you will need to set ENV vars for your `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY`. You will need Terraform installed.

Then check the variables and CIDR block are suitable for your needs.

Then `terraform init`, `terraform plan`, `terraform apply` if you are happy with everything.

Future enhancements:

* More templating and variables in the Terraform
* Try to get the EC2 instances into private subnets
* Domains and certificates
* Config management for the actual application payload