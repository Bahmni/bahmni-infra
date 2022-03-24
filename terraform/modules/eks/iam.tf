resource "aws_iam_role" "eks-service-role" {
  name = "bahmni-eks-service-role-${var.environment}"

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
    Name  = "bahmni-eks-service-role-${var.environment}"
    owner = var.owner
  }
}

resource "aws_iam_role_policy_attachment" "eks-service-role-EKSClusterPolicy-attachemnt" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks-service-role.name
}
