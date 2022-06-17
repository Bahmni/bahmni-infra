output "eks_cluster_name" {
  value       = module.non_prod_eks.cluster-name
  description = "Name of the EKS Cluster"
}
