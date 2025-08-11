resource "aws_alb" "main" {
  name               = "${var.project_name}-network-loadbalancer"
  internal           = "false"
  load_balancer_type = "network"
  security_groups    = [aws_security_group.loadbalancer.id]
  subnets            = split(",", data.aws_ssm_parameter.public_subnet[0].value)
  enable_zonal_shift = true

  tags = {
    Name = "${var.project_name}-network-loadbalancer"
  }
}

resource "aws_alb_target_group" "main" {
  name     = "istio-target-group"
  port     = 443
  protocol = "TCP"
  vpc_id   = data.aws_ssm_parameter.vpc[0].value
}

resource "aws_alb_listener" "listiner_443" {
  load_balancer_arn = aws_alb.main.arn
  port              = 443
  protocol          = "TLS"
  ssl_policy        = var.network_loadbalancer_ssl_policy
  certificate_arn   = var.certificado_listiner_443
  default_action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.main.arn
  }
}


resource "aws_security_group" "loadbalancer" {
  name   = "${var.project_name}-network-loadbalancer-sg"
  vpc_id = var.solidstack_vpc_module ? data.aws_ssm_parameter.vpc[0].value : var.vpc_id

  tags = {
    Name = "${var.project_name}-network-loadbalancer-sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_443" {
  security_group_id = aws_security_group.loadbalancer.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 443
  ip_protocol       = "tcp"
  to_port           = 443
}

resource "aws_vpc_security_group_ingress_rule" "allow_80" {
  security_group_id = aws_security_group.loadbalancer.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}

resource "aws_vpc_security_group_ingress_rule" "allow_tls_ipv6_443" {
  security_group_id = aws_security_group.loadbalancer.id
  cidr_ipv6         = "::/0"
  from_port         = 443
  ip_protocol       = "tcp"
  to_port           = 443
}

resource "aws_vpc_security_group_ingress_rule" "allow_tls_ipv6_80" {
  security_group_id = aws_security_group.loadbalancer.id
  cidr_ipv6         = "::/0"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.loadbalancer.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv6" {
  security_group_id = aws_security_group.loadbalancer.id
  cidr_ipv6         = "::/0"
  ip_protocol       = "-1"
}

