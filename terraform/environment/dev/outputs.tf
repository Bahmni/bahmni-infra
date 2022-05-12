output "eks_cluster_name" {
  value       = module.dev_eks.cluster-name
  description = "Name of the EKS Cluster"
}

output "user_aceess_role_arn" {
  value       = module.dev_eks.user_access_role_arn
  description = "ARN of the role used to create identity mapping in EKS cluster"
}
