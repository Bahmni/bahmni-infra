resource "aws_security_group" "cluster" {
  name        = "${var.name_prefix}-cluster-sg"
  description = "Cluster communication with worker nodes"
  vpc_id      = data.aws_vpc.bahmni-vpc.id

  tags = {
    Name = "${var.name_prefix}-cluster-sg"
  }
}

resource "aws_security_group" "node" {
  name        = "${var.name_prefix}-node-sg"
  description = "Security group for all nodes in the EKS cluster"
  vpc_id      = data.aws_vpc.bahmni-vpc.id

  tags = {
    Name = "${var.name_prefix}-node-sg"
  }
}
