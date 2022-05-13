output "cluster-name" {
  value = aws_eks_cluster.bahmni-cluster.name
}

output "endpoint" {
  value = aws_eks_cluster.bahmni-cluster.endpoint
}

output "kubeconfig-certificate-authority-data" {
  value = aws_eks_cluster.bahmni-cluster.certificate_authority[0].data
}

output "eks_read_only_access_role_arn" {
  value = aws_iam_role.eks_read_only.arn
}

output "eks_read_only_access_policy_arn" {
  value = aws_iam_policy.assume_role_eks_read_only_role.arn
}
