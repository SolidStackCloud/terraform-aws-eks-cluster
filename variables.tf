variable "region" {
  description = "Região onde os recursos serão construídos"
  type        = string
}
variable "project_name" {
  description = "Nome do projeto"
  type        = string
}

variable "solidstack_vpc_module" {
  description = "Se true, o módulo usará os recursos (VPC, subnets, etc.) criados pelo módulo VPC da SolidStack, buscando-os no SSM Parameter Store. O 'project_name' deve ser o mesmo em ambos os módulos."
  type        = bool
  default     = true
}

variable "public_subnets" {
  description = "Lista de IDs das subnets públicas. Usado apenas se 'solidstack_vpc_module' for false."
  type        = list(string)
  default     = []
}

variable "pods_subnets" {
  description = "Lista de IDs das subnets de pods. Usado apenas se 'solidstack_vpc_module' for false. Recomendamos a adição de uma CIDR na VPC e a configuração de uma mascara de rede que possibilite um grande número de ips para os pods"
  type        = list(string)
  default     = []
}

variable "privates_subnets" {
  description = "Lista de IDs das subnets privadas. Usado apenas se 'solidstack_vpc_module' for false."
  type        = list(string)
  default     = []
}

variable "vpc_id" {
  description = "ID da VPC onde o serviço será implantado. Usado apenas se 'solidstack_vpc_module' for false."
  type        = string
  default     = ""
}

variable "vpc_cidr" {
  description = "Bloco CIDR da VPC. Usado para a regra de entrada do security group. Usado apenas se 'solidstack_vpc_module' for false."
  type        = string
  default     = ""
}

variable "cluster_version" {
  description = "Versão do cluster EKS desejada."
  type        = string
}

variable "endpoint_public_access" {
  description = "Deseja habilitar o acesso público a API do cluster?"
  type        = bool
  default     = true
}

variable "endpoint_private_access" {
  description = "Deseja habilitar o acesso privado a API do cluster?"
  type        = bool
  default     = true
}



############################ ADDONS

variable "vpc_cni_version" {
  description = "Versão desejada do addon VPC-CNI"
  type        = string
}

variable "coredns_version" {
  description = "Versão desejada do addon CoreDNS"
  type        = string
}

variable "kube_proxy" {
  description = "Versão desejada do addon Kube-Proxy"
  type        = string
}

variable "eks_pod_identity_agent" {
  description = "Versão desejada do addon EKS-Pod-Identity-Agent"
  type        = string
}

variable "metrics_server" {
  description = "Versão desejada do addon Metrics-Server"
  type        = string
}

## Karpenter

variable "karpenter_version" {
  description = "The version of the Karpenter Helm chart to install."
  type        = string
  default     = "1.6.0"
}

variable "ami_family" {
  description = "The AMI family for the nodes."
  type        = string
  default     = "Bottlerocket"
}

variable "ami_id" {
  description = "The AMI ID for the nodes."
  type        = string
  default     = ""
}

variable "nodepool_consolidate_after" {
  description = "The duration after which Karpenter will consolidate nodes."
  type        = string
  default     = "5m"
}

variable "nodepool_instance_families" {
  description = "The instance families for the NodePool."
  type        = list(string)
  default     = ["m5", "c5", "c6a", "m6a", "c7a"]
}

variable "nodepool_capacity_types" {
  description = "The capacity types for the NodePool."
  type        = list(string)
  default     = ["spot", "on-demand"]
}

variable "nodepool_instance_sizes" {
  description = "The instance sizes for the NodePool."
  type        = list(string)
  default     = ["large", "xlarge", "2xlarge"]
}