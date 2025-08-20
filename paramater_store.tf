resource "aws_ssm_parameter" "cluster_name" {
  type = "String"
  name  = "/${var.project_name}/cluster-name"
  value = aws_eks_cluster.main.id
}

resource "aws_ssm_parameter" "oidc_arn" {
  type = "String"
  name  = "/${var.project_name}/oidc-arn"
  value = aws_iam_openid_connect_provider.default.arn
}