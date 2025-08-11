resource "aws_eks_fargate_profile" "karpenter" {
  cluster_name           = aws_eks_cluster.main.id
  fargate_profile_name   = "${var.project_name}-karpenter"
  pod_execution_role_arn = aws_iam_role.karpenter_fargate_profile.arn
  subnet_ids             = var.solidstack_vpc_module ? tolist(split(",", data.aws_ssm_parameter.pods_subnet[0].value)) : var.pods_subnets
  selector {
    namespace = "karpenter"
  }
}

resource "aws_iam_role" "karpenter_fargate_profile" {
  name = "${var.project_name}-karpenter-fargate-profile"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "sts:AssumeRole",
          "sts:TagSession"
        ]
        Effect = "Allow"
        Principal = {
          Service = "eks-fargate-pods.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "karpenter_AmazonEKSFargatePodExecutionRolePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSFargatePodExecutionRolePolicy"
  role       = aws_iam_role.karpenter_fargate_profile.name
}