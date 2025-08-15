resource "aws_eks_addon" "vpc_cni" {
  cluster_name                = aws_eks_cluster.main.name
  addon_name                  = "vpc-cni"
  addon_version               = var.vpc_cni_version
  resolve_conflicts_on_create = "OVERWRITE"
  resolve_conflicts_on_update = "OVERWRITE"
}

resource "aws_eks_addon" "coredns" {
  cluster_name                = aws_eks_cluster.main.name
  addon_name                  = "coredns"
  addon_version               = var.coredns_version
  resolve_conflicts_on_create = "OVERWRITE"
  resolve_conflicts_on_update = "OVERWRITE"


}

resource "aws_eks_addon" "kube_proxy" {
  cluster_name                = aws_eks_cluster.main.name
  addon_name                  = "kube-proxy"
  addon_version               = var.kube_proxy
  resolve_conflicts_on_create = "OVERWRITE"
  resolve_conflicts_on_update = "OVERWRITE"
}

resource "aws_eks_addon" "eks_pod_identity_agent" {
  cluster_name                = aws_eks_cluster.main.name
  addon_name                  = "eks-pod-identity-agent"
  addon_version               = var.eks_pod_identity_agent
  resolve_conflicts_on_create = "OVERWRITE"
  resolve_conflicts_on_update = "OVERWRITE"

}

resource "aws_eks_addon" "metrics_server" {
  cluster_name                = aws_eks_cluster.main.name
  addon_name                  = "metrics-server"
  addon_version               = var.metrics_server
  resolve_conflicts_on_create = "OVERWRITE"
  resolve_conflicts_on_update = "OVERWRITE"
}

### EFS CSI Driver

resource "aws_eks_addon" "efs_csi" {
  cluster_name = aws_eks_cluster.main.name
  addon_name   = "aws-efs-csi-driver"

  addon_version               = var.addon_efs_csi_version
  resolve_conflicts_on_create = "OVERWRITE"
  resolve_conflicts_on_update = "OVERWRITE"
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


### EBS

# data "aws_iam_policy_document" "loki_role" {
#   version = "2012-10-17"

#   statement {
#     effect = "Allow"

#     principals {
#       type        = "Service"
#       identifiers = ["pods.eks.amazonaws.com"]
#     }

#     actions = [
#       "sts:AssumeRole",
#       "sts:TagSession"
#     ]
#   }
# }

# resource "aws_iam_role" "loki_role" {
#   assume_role_policy = data.aws_iam_policy_document.loki_role.json
#   name               = format("%s-loki", var.project_name)
# }

# data "aws_iam_policy_document" "loki_policy" {
#   version = "2012-10-17"

#   statement {

#     effect = "Allow"
#     actions = [
#       "s3:*",
#     ]

#     resources = [
#       format("%s/*", aws_s3_bucket.loki-chunks.arn),
#       format("%s/*", aws_s3_bucket.loki-admin.arn),
#       format("%s/*", aws_s3_bucket.loki-ruler.arn),
#       aws_s3_bucket.loki-chunks.arn,
#       aws_s3_bucket.loki-admin.arn,
#       aws_s3_bucket.loki-ruler.arn,
#     ]

#   }
# }

# resource "aws_iam_policy" "loki_policy" {
#   name        = format("%s-loki", var.project_name)
#   path        = "/"
#   description = var.project_name

#   policy = data.aws_iam_policy_document.loki_policy.json
# }

# resource "aws_iam_policy_attachment" "loki" {
#   name = "loki"
#   roles = [
#     aws_iam_role.loki_role.name
#   ]

#   policy_arn = aws_iam_policy.loki_policy.arn
# }

# resource "aws_eks_pod_identity_association" "loki" {
#   cluster_name    = aws_eks_cluster.main.name
#   namespace       = "loki"
#   service_account = "loki"
#   role_arn        = aws_iam_role.loki_role.arn
# }