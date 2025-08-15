resource "aws_ssm_parameter" "cluster_name" {
  type = "String"
  name  = "/${var.project_name}/cluster-name"
  value = aws_eks_cluster.main.name
}

resource "aws_ssm_parameter" "oidc_arn" {
  type = "String"
  name  = "/${var.project_name}/oidc_arn"
  value = aws_iam_openid_connect_provider.eks.arn
}