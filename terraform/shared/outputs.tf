output "eks_read_only_access_role_arn" {
  value       = aws_iam_role.eks_read_only.arn
  description = "ARN of Read Only Access Role to EKS"
}