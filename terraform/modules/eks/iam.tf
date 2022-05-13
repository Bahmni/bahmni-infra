## IAM Roles and policies for Node

resource "aws_iam_role" "node-role" {
  name = "BahmniEKSNodeRole-${var.environment}"

  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
    Version = "2012-10-17"
  })

  tags = {
    Name  = "BahmniEKSNodeRole-${var.environment}"
    owner = var.owner
  }
}

resource "aws_iam_role_policy_attachment" "node_AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.node-role.name
}

resource "aws_iam_role_policy_attachment" "node_AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.node-role.name
}

resource "aws_iam_role_policy_attachment" "node_AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.node-role.name
}

## IAM Roles and policies for Cluster

resource "aws_iam_role" "cluster-role" {
  name = "BahmniEKSClusterRole-${var.environment}"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
  tags = {
    Name  = "BahmniEKSClusterRole-${var.environment}"
    owner = var.owner
  }
}

resource "aws_iam_role_policy_attachment" "cluster_EKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.cluster-role.name
}

resource "aws_iam_role_policy_attachment" "cluster_EKSServicePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
  role       = aws_iam_role.cluster-role.name
}

resource "aws_iam_role" "eks_read_only" {
  name               = "BahmniEKSReadOnlyRoleForIAMUsers"
  assume_role_policy = data.aws_iam_policy_document.assume_role_iam_users_policy_document.json
  tags = {
    environment = var.environment
  }
}

resource "aws_iam_policy" "eks_describe_cluster" {
  name = "BahmniEKSDescribeCluster"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "eks:DescribeCluster",
        ]
        Effect   = "Allow"
        Resource = aws_eks_cluster.bahmni-cluster.arn
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "describe_cluster_attachment_to_readonly_role" {
  policy_arn = aws_iam_policy.eks_describe_cluster.arn
  role       = aws_iam_role.eks_read_only.name
}

resource "aws_iam_policy" "assume_role_eks_read_only_role" {
  name = "BahmniEKSClusterReadOnlyAccess"
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
  tags = {
    environment = var.environment
  }
}
