resource "aws_security_group" "bastion" {
  name        = "bahmni-bastion-sg-${var.vpc_suffix}"
  description = "SG for Bahmni Bastion Host"
  vpc_id      = data.aws_vpc.bahmni-vpc.id
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "bahmni-bastion-sg-${var.vpc_suffix}"
  }
}