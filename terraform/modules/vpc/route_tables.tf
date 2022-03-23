resource "aws_route_table" "public" {
  vpc_id = aws_vpc.bahmni-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name  = "bahmni-rt-${var.vpc_suffix}"
    owner = var.owner
  }
}

resource "aws_route_table_association" "public" {
  count          = 1
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}
