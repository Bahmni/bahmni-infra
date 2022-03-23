output "vpc-info" {
  value = {
    vpc_id            = aws_vpc.bahmni-vpc.id
    private_subnet_id = aws_subnet.private.id
    public_subnet_id  = aws_subnet.public.id
  }

}