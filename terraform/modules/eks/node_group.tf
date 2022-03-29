resource "aws_eks_node_group" "example" {
  cluster_name    = aws_eks_cluster.bahmni-cluster.name
  node_group_name = "default-node-group"
  node_role_arn   = aws_iam_role.node.arn
  subnet_ids      = data.aws_subnets.private_subnets.ids
  instance_types  = [var.node_instance_type]
  capacity_type   = "ON_DEMAND"
  # launch_template {
  #   id = aws_launch_template.node_launch_template.id
  #   version = 1
  # }

  scaling_config {
    desired_size = 1
    max_size     = 1
    min_size     = 1
  }

  update_config {
    max_unavailable = 1
  }

  # Ensure that IAM Role permissions are created before and deleted after EKS Node Group handling.
  # Otherwise, EKS will not be able to properly delete EC2 Instances and Elastic Network Interfaces.
  depends_on = [
    aws_iam_role_policy_attachment.node_AmazonEC2ContainerRegistryReadOnly,
    aws_iam_role_policy_attachment.node_AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.node_AmazonEKSWorkerNodePolicy
  ]
}

resource "aws_launch_template" "node_launch_template" {
  key_name = var.keyname
}