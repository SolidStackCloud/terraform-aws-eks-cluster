resource "helm_release" "prometheus" {

  name             = "prometheus"
  chart            = "kube-prometheus-stack"
  repository       = "https://prometheus-community.github.io/helm-charts"
  namespace        = "prometheus"
  create_namespace = true
  replace = true
  cleanup_on_fail = true

  version = "76.2.0"

  values = [
    "${file("./helm/prometheus.yml")}"
  ]

  depends_on = [
    aws_eks_cluster.main,
    helm_release.karpenter, 
    aws_eks_addon.efs_csi
  ]
}

