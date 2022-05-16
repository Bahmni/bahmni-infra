data "aws_caller_identity" "current_account_info" {}
data "aws_region" "current" {}
data "aws_iam_group" "eks_read_only" {
  group_name = "bahmni_eks_read_only"
}

resource "aws_iam_role" "eks_read_only" {
  name = "BahmniEKSReadOnlyRoleForIAMUsers"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          "AWS" : "arn:aws:iam::${data.aws_caller_identity.current_account_info.account_id}:root"
        }
      },
    ]
  })

  inline_policy {
    name = "EKSDescribeClusterAccess"

    policy = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          Action   = ["eks:DescribeCluster"]
          Effect   = "Allow"
          Resource = "arn:aws:eks:${data.aws_region.current.name}:${data.aws_caller_identity.current_account_info.account_id}:cluster/*"
        },
      ]
    })
  }

}

resource "aws_iam_policy" "eks_read_only_assume_role_policy" {
  name = "BahmniEKSReadOnlyAssumeRoleAccess"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "sts:AssumeRole",
        ]
        Effect   = "Allow"
        Resource = aws_iam_role.eks_read_only.arn
      },
    ]
  })
}

resource "aws_iam_group_policy_attachment" "eks_read_only_group_assume_role_policy" {
  group      = data.aws_iam_group.eks_read_only.group_name
  policy_arn = aws_iam_policy.eks_read_only_assume_role_policy.arn
}
