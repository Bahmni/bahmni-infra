resource "aws_eks_cluster" "bahmni-cluster" {
  name     = "bahmni-cluster"
  role_arn = aws_iam_role.cluster.arn

  vpc_config {
    subnet_ids = data.aws_subnets.private_subnets.ids
    security_group_ids = [aws_security_group.cluster.id]
    endpoint_private_access = true
    endpoint_public_access  = true
  }

  depends_on = [
    aws_iam_role_policy_attachment.cluster_EKSClusterPolicy,
    aws_iam_role_policy_attachment.cluster_EKSServicePolicy,
  ]
}

