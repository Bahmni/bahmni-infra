output "eks_cluster_name" {
  value       = module.dev_eks.cluster-name
  description = "Name of the EKS Cluster"
}
