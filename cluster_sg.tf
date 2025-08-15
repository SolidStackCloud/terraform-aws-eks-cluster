resource "aws_security_group_rule" "nodeports" {
  for_each = var.add_rule_cluster_security_group
  cidr_blocks       = each.value.cidr_blocks
  from_port         = each.value.from_port
  to_port           = each.value.to_port
  protocol          = each.value.protocol
  description       = each.value.description
  type              = "ingress"
  security_group_id = aws_eks_cluster.main.vpc_config[0].cluster_security_group_id

  depends_on = [ aws_eks_cluster.main ]
}
