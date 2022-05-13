output "eks_cluster_name" {
  value       = module.dev_eks.cluster-name
  description = "Name of the EKS Cluster"
}

output "eks_read_only_access_role_arn" {
  value       = module.dev_eks.eks_read_only_access_role_arn
  description = "ARN of the role for EKS Read Only Access"
}

output "eks_read_only_access_policy_arn" {
  value       = module.dev_eks.eks_read_only_access_policy_arn
  description = "ARN of the policy for EKS Read Only Access"
}
