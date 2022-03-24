output "endpoint" {
  value = aws_eks_cluster.bahmni-cluster.endpoint
}

output "kubeconfig-certificate-authority-data" {
  value = aws_eks_cluster.bahmni-cluster.certificate_authority[0].data
}
