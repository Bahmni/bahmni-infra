data "aws_ami" "aws-linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-kernel-5.10-hvm-2.0.20220316.0-x86_64-gp2"]
  }
}

data "aws_vpc" "bahmni-vpc" {
  filter {
    name   = "tag:Name"
    values = ["bahmni-vpc-${var.vpc_suffix}"]
  }
}

data "aws_subnets" "private_subnets" {
  filter {
    name   = "vpc-id"
    values = ["${data.aws_vpc.bahmni-vpc.id}"]
  }
  filter {
    name   = "tag:Subnet-Type"
    values = ["private-${var.vpc_suffix}"]
  }
}
