data "aws_ami" "aws-linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["Amazon Linux 2 AMI (HVM) - Kernel 5.10"]
  }
}

data "aws_vpc" "bahmni-vpc" {
  filter {
    name   = "tag:Name"
    values = ["bahmni-vpc-${var.vpc_suffix}"]
  }
}

data "aws_subnet_ids" "private_subnet_ids" {
  vpc_id = data.aws_vpc.bahmni-vpc.id
  filter {
    name   = "tag:Subnet-Type"
    values = ["private-${var.vpc_suffix}"]
  }
}
