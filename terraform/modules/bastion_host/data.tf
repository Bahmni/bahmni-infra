data "aws_ami" "amazon_linux_2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = [var.ami_name]
  }
}

data "aws_vpc" "bahmni-vpc" {
  filter {
    name   = "tag:Name"
    values = ["bahmni-vpc-${var.vpc_suffix}"]
  }
}

data "aws_subnets" "public_subnets" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.bahmni-vpc.id]
  }
  filter {
    name   = "tag:Subnet-Type"
    values = ["public-${var.vpc_suffix}"]
  }
}

data "template_file" "user_data_bastion" {
  template = file("${path.module}/user_data.tpl")
}