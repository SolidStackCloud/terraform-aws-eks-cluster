resource "aws_ssm_parameter" "cluster_name" {
  type = "String"
  name  = "/${var.project_name}/cluster-name"
  value = aws_eks_cluster.main.id
}

