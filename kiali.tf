resource "helm_release" "kiali-server" {
  name       = "kiali-server"
  chart      = "kiali-server"
  repository = "https://kiali.org/helm-charts"
  namespace  = "istio-system"

  create_namespace = true

  version = "2.14.0"

  set = [
  {
    name  = "server.web_fqdn"
    value = "kiali.${var.dominio}"
  },
  {
    name  = "auth.strategy"
    value = "anonymous"
  },
  {
    name  = "external_services.tracing.use_grpc"
    value = "false"
  },
  {
    name  = "external_services.tracing.enabled"
    value = "true"
  },
  {
    name  = "external_services.tracing.internal_url"
    value = "http://jaeger-query.tracing.svc.cluster.local:16686"
  },
  {
    name  = "external_services.tracing.external_url"
    value = "http://jaeger.${var.dominio}"
  },
  {
    name  = "external_services.prometheus.url"
    value = "http://prometheus-kube-prometheus-prometheus.prometheus.svc.cluster.local:9090"
  },
  {
    name  = "external_services.grafana.enabled"
    value = "true"
  },
  {
    name  = "external_services.grafana.external_url"
    value = "http://grafana.${var.dominio}"
  },
  {
    name  = "external_services.grafana.internal_url"
    value = "http://prometheus-grafana.prometheus.svc.cluster.local:80"
  },
  {
    name  = "external_services.grafana.auth.type"
    value = "basic"
  },
  {
    name  = "external_services.grafana.auth.insecure_skip_verify"
    value = "true"
  },
  {
    name  = "external_services.grafana.auth.username"
    value = "admin"
  },
  {
    name  = "external_services.grafana.auth.password"
    value = "123@Select"
  },
  {
    name  = "external_services.grafana.dashboards[0].name"
    value = "Istio Mesh Dashboard"
  },
  {
    name  = "external_services.grafana.dashboards[1].name"
    value = "Istio Service Dashboard"
  },
  {
    name  = "external_services.grafana.dashboards[1].variables.namespace"
    value = "var-namespace"
  },
  {
    name  = "external_services.grafana.dashboards[1].variables.service"
    value = "var-service"
  },
  {
    name  = "external_services.grafana.dashboards[2].name"
    value = "Istio Workload Dashboard"
  },
  {
    name  = "external_services.grafana.dashboards[2].variables.namespace"
    value = "var-namespace"
  },
  {
    name  = "external_services.grafana.dashboards[2].variables.workload"
    value = "var-workload"
  },
  {
    name  = "external_services.grafana.dashboards[3].name"
    value = "Istio Performance Dashboard"
  }
]



  depends_on = [
    helm_release.istio_base,
    helm_release.istiod,
    helm_release.istio_ingress
  ]
}

# resource "kubectl_manifest" "jaeger_gateway" {
#   yaml_body = <<YAML
# apiVersion: networking.istio.io/v1alpha3
# kind: Gateway
# metadata:
#   name: jaeger-query
#   namespace: tracing
# spec:
#   selector:
#     istio: ingressgateway
#   servers:
#   - port:
#       number: 80
#       name: http
#       protocol: HTTP
#     hosts:
#     - "jaeger.${var.dominio}"
# YAML

#   depends_on = [
#     helm_release.jaeger,
#     helm_release.istio_ingress
#   ]

# }

# resource "kubectl_manifest" "jaeger_virtual_service" {
#   yaml_body = <<YAML
# apiVersion: networking.istio.io/v1alpha3
# kind: VirtualService
# metadata:
#   name: jaeger-query
#   namespace: tracing
# spec:
#   hosts:
#   - "jaeger.${var.dominio}"
#   gateways:
#   - jaeger-query
#   http:
#   - route:
#     - destination:
#         host: jaeger-query
#         port:
#           number: 16686 
# YAML

#   depends_on = [
#     helm_release.jaeger,
#     helm_release.istio_ingress
#   ]

# }