resource "aws_security_group" "cluster" {
  name        = "${var.name_prefix}-cluster-sg"
  description = "Cluster communication with worker nodes"
  vpc_id      = data.aws_vpc.bahmni-vpc.id

  tags = {
    Name = "${var.name_prefix}-cluster-sg"
  }
}

//resource "aws_security_group_rule" "cluster_ingress_https" {
//  cidr_blocks       = var.cluster_whitelist_ips
//  description       = "This is for bahmni eks cluster creation"
//  from_port         = 443
//  protocol          = "tcp"
//  security_group_id = aws_security_group.cluster.id
//  to_port           = 443
//  type              = "ingress"
//}

resource "aws_security_group" "node" {
  name        = "${var.name_prefix}-node-sg"
  description = "Security group for all nodes in the EKS cluster"
  vpc_id      = data.aws_vpc.bahmni-vpc.id

  tags = {
    Name = "${var.name_prefix}-node-sg"
  }
}
