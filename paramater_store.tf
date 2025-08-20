resource "aws_ssm_parameter" "cluster_name" {
  type = "String"
  name  = "/${var.project_name}/cluster-name"
  value = aws_eks_cluster.main.id
}

resource "aws_ssm_parameter" "instance_profile" {
  type = "String"
  name  = "/${var.project_name}/instance-profile"
  value = aws_iam_instance_profile.workers_nodes.arn
}