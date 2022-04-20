resource "aws_instance" "bastion" {
  ami                         = data.aws_ami.amazon_linux_2.id
  instance_type               = "t3.micro"
  vpc_security_group_ids      = [aws_security_group.bastion.id]
  associate_public_ip_address = true
  subnet_id                   = data.aws_subnets.public_subnets.ids[0]
  user_data                   = data.template_file.user_data_bastion.rendered

  tags = {
    Name = "Bahmni Bastion - ${var.vpc_suffix} VPC"
  }
}

