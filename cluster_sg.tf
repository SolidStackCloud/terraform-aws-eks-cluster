resource "aws_security_group_rule" "nodeports" {
  for_each = { for regra, r in var.cluster_sg : regra => r }
  from_port   = each.value.from_port
  to_port     = each.value.to_port
  protocol    = each.value.protocol
  cidr_blocks = each.value.cidr_blocks
  description = each.value.description
  type              = each.value.type
  security_group_id = aws_eks_cluster.main.vpc_config[0].cluster_security_group_id
}
