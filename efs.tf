resource "aws_efs_file_system" "grafana" {
  creation_token   = format("%s-efs-grafana", var.project_name)
  performance_mode = "generalPurpose"

  tags = {
    Name = format("%s-efs-grafana", var.project_name)
  }
}

resource "aws_efs_mount_target" "grafana" {
  count = length(aws_eks_cluster.main.vpc_config[0].subnet_ids)



  file_system_id = aws_efs_file_system.grafana.id
  subnet_id      = tolist(aws_eks_cluster.main.vpc_config[0].subnet_ids)[count.index]
  security_groups = [
    aws_security_group.efs.id
  ]
  depends_on = [helm_release.karpenter]
}

resource "kubectl_manifest" "grafana_efs_storage_class" {
  yaml_body = <<YAML
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: efs-grafana
provisioner: efs.csi.aws.com
parameters:
  provisioningMode: efs-ap
  fileSystemId: ${aws_efs_file_system.grafana.id}
  directoryPerms: "777"
reclaimPolicy: Retain
volumeBindingMode: WaitForFirstConsumer
YAML

  depends_on = [
    aws_eks_cluster.main,
    helm_release.karpenter
  ]
}


## PROMETHEUS

resource "aws_efs_file_system" "prometheus" {
  creation_token   = format("%s-efs-prometheus", var.project_name)
  performance_mode = "generalPurpose"

  tags = {
    Name = format("%s-efs-prometheus", var.project_name)
  }
}

resource "aws_efs_mount_target" "prometheus" {
  count = length(aws_eks_cluster.main.vpc_config[0].subnet_ids)


  file_system_id = aws_efs_file_system.prometheus.id
  subnet_id      = tolist(aws_eks_cluster.main.vpc_config[0].subnet_ids)[count.index]
  security_groups = [
    aws_security_group.efs.id
  ]
}

resource "aws_security_group" "efs" {
  name   = format("%s-efs", var.project_name)
  vpc_id = data.aws_ssm_parameter.vpc[0].value

  ingress {
    from_port   = 2049
    to_port     = 2049
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "kubectl_manifest" "prometheus_efs_storage_class" {
  yaml_body = <<YAML
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: efs-prometheus
provisioner: efs.csi.aws.com
parameters:
  provisioningMode: efs-ap
  fileSystemId: ${aws_efs_file_system.prometheus.id}
  directoryPerms: "777"
reclaimPolicy: Retain
volumeBindingMode: WaitForFirstConsumer
YAML

  depends_on = [
    aws_eks_cluster.main,
    helm_release.karpenter
  ]
}

data "aws_iam_policy_document" "efs_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["pods.eks.amazonaws.com"]
    }

    actions = [
      "sts:AssumeRole",
      "sts:TagSession"
    ]
  }
}

resource "aws_iam_role" "efs_role" {
  assume_role_policy = data.aws_iam_policy_document.efs_role.json
  name               = format("%s-efs-csi-role", var.project_name)
}

resource "aws_iam_role_policy_attachment" "efs_csi_role" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEFSCSIDriverPolicy"
  role       = aws_iam_role.efs_role.name
}

resource "aws_eks_pod_identity_association" "efs_csi" {
  cluster_name    = aws_eks_cluster.main.name
  namespace       = "kube-system"
  service_account = "efs-csi-controller-sa"
  role_arn        = aws_iam_role.efs_role.arn
}

