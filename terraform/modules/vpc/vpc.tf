resource "aws_vpc" "bahmni-vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  instance_tenancy     = "default"
  tags = {
    Name  = "bahmni-vpc-${var.vpc_suffix}"
    owner = var.owner
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.bahmni-vpc.id

  tags = {
    Name  = "bahmni-igw-${var.vpc_suffix}"
    owner = var.owner
  }
}

resource "aws_eip" "nat_eip" {
  vpc        = true
  depends_on = [aws_internet_gateway.igw]
  tags = {
    Name  = "bahmni-nat-eip-${var.vpc_suffix}"
    owner = var.owner
  }
}

resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public.id

  tags = {
    Name  = "bahmni-nat-gateway-${var.vpc_suffix}"
    owner = var.owner
  }
}
