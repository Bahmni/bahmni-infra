resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.Bahmni-vpc.id
  availability_zone       = var.region
  cidr_block              = "10.0.0.0/24"
  map_public_ip_on_launch = true

  tags = {
    Name  = "bahmni-public-subnet"
    owner = "bahmni-infra"
  }
}

resource "aws_subnet" "private" {
  vpc_id                  = aws_vpc.Bahmni-vpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = false

  tags = {
    Name  = "bahmni-private-subnet"
    owner = "bahmni-infra"
  }
}

