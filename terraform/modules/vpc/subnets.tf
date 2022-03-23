resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.bahmni-vpc.id
  availability_zone       = var.availability_zone
  cidr_block              = "10.0.0.0/24"
  map_public_ip_on_launch = true

  tags = {
    Name  = "bahmni-public-subnet-${var.vpc_suffix}"
    owner = var.owner
  }
}

resource "aws_subnet" "private" {
  vpc_id                  = aws_vpc.bahmni-vpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = false

  tags = {
    Name  = "bahmni-private-subnet-${var.vpc_suffix}"
    owner = var.owner
  }
}

