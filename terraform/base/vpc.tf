resource "aws_vpc" "Bahmni-vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  instance_tenancy     = "default"
  tags = {
    Name  = "bahmni-vpc"
    owner = "bahmni-infra"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.Bahmni-vpc.id

  tags = {
    Name  = "bahmni-igw"
    owner = "bahmni-infra"
  }
}

resource "aws_eip" "nat_eip" {
  vpc        = true
  depends_on = [aws_internet_gateway.igw]
  tags = {
    Name  = "bahmni-nat-eip"
    owner = "bahmni-infra"
  }
}

resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public.id

  tags = {
    Name  = "bahmni-nat-gateway"
    owner = "bahmni-infra"
  }
}
