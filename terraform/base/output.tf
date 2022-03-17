locals {
  value = {
    VPC_id         = aws_vpc.Bahmni-vpc.id
    Subnet_public  = aws_subnet.public.id
    Subnet_private = aws_subnet.private.id
    //    //    Subnet_private = aws_subnet.private.id
    //    SecurityGroup               = aws_security_group.allow_web.id
    //    SecurityGroupForJavaServers = aws_security_group.java_server.id
  }
}
output "VPC-info" {
  value = local.value
}