data "aws_ssm_parameter" "vpc" {
  count = var.solidstack_vpc_module ? 1 : 0
  name  = "/${var.project_name}/vpc-id"
}

data "aws_ssm_parameter" "private_subnet" {
  count = var.solidstack_vpc_module ? 1 : 0
  name  = "/${var.project_name}/private-subnet-ids"
}

data "aws_ssm_parameter" "public_subnet" {
  count = var.solidstack_vpc_module ? 1 : 0
  name  = "/${var.project_name}/public-subnet-ids"
}

data "aws_ssm_parameter" "pods_subnet" {
  count = var.solidstack_vpc_module ? 1 : 0
  name  = "/${var.project_name}/pods-subnet-ids"
}
