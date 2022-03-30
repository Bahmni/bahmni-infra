resource "aws_eks_node_group" "default" {
  cluster_name    = aws_eks_cluster.bahmni-cluster.name
  node_group_name = "node-group-${var.environment}"
  node_role_arn   = aws_iam_role.node-role.arn
  subnet_ids      = data.aws_subnets.private_subnets.ids
  instance_types  = [var.node_instance_type]
  capacity_type   = "ON_DEMAND"

  scaling_config {
    desired_size = var.desired_num_of_nodes
    max_size     = var.max_num_of_nodes
    min_size     = var.min_num_of_nodes
  }

  # Ensure that IAM Role permissions are created before and deleted after EKS Node Group handling.
  # Otherwise, EKS will not be able to properly delete EC2 Instances and Elastic Network Interfaces.
  depends_on = [
    aws_iam_role_policy_attachment.node_AmazonEC2ContainerRegistryReadOnly,
    aws_iam_role_policy_attachment.node_AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.node_AmazonEKSWorkerNodePolicy
  ]

  tags = {
    Name  = "bahmni-node-group-${var.environment}"
    owner = var.owner
  }
}
