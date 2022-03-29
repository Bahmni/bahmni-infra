resource "aws_security_group" "cluster" {
  name        = "${var.name_prefix}-cluster-sg"
  description = "Cluster communication with worker nodes"
  vpc_id      = data.aws_vpc.bahmni-vpc.id

  tags = {
    Name = "${var.name_prefix}-cluster-sg"
  }
}

resource "aws_security_group_rule" "cluster_ingress_https" {
  # cidr_blocks       = var.cluster_whitelist_ips
  description       = "Allow workstation to communicate with the cluster API Server"
  from_port         = 443
  protocol          = "tcp"
  security_group_id = aws_security_group.cluster.id
  to_port           = 443
  type              = "ingress"
}

resource "aws_security_group" "node" {
  name        = "${var.name_prefix}-node-sg"
  description = "Security group for all nodes in the EKS cluster"
  vpc_id      = data.aws_vpc.bahmni-vpc.id

  tags = {
    Name = "${var.name_prefix}-node-sg"
    "kubernetes.io/cluster/bahmni-cluster" = "owned"
  }
}

resource "aws_security_group_rule" "node_ingress_self" {
  description              = "Allow node to communicate with each other"
  from_port                = 0
  protocol                 = "-1"
  security_group_id        = aws_security_group.node.id
  source_security_group_id = aws_security_group.node.id
  to_port                  = 65535
  type                     = "ingress"
}

resource "aws_security_group_rule" "node_ingress_cluster" {
  description              = "Allow worker Kubelets and pods to receive communication from the cluster control plane"
  from_port                = 1025
  protocol                 = "tcp"
  security_group_id        = aws_security_group.node.id
  source_security_group_id = aws_security_group.cluster.id
  to_port                  = 65535
  type                     = "ingress"
}

resource "aws_security_group_rule" "cluster_ingress_node_https" {
  description              = "Allow pods to communicate with the cluster API Server"
  from_port                = 443
  protocol                 = "tcp"
  security_group_id        = aws_security_group.cluster.id
  source_security_group_id = aws_security_group.node.id
  to_port                  = 443
  type                     = "ingress"
}