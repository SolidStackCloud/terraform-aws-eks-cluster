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

variable "addon_efs_csi_version" {
  description = "Versão desejada do addon addon_efs_csi_version"
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


#### Node Group

variable "nodegroup_instance_types" {
  description = "Utilizada para especificar os tipos de instâncias do NodeGroup"
  type = list(string)
  default = ["c6i.large"]
}

variable "ami_type" {
  description = "Utilizada para especificar o AMI id utilizado pelo NodeGroup"
  type = string
  default = "BOTTLEROCKET_x86_64"
}

variable "disk_size" {
  description = "Ajustes no tamanho do disco das instâncais do NodeGroup"
  type = string
  default = "100"
}

variable "scaling_config" {
  description = "Utilizada para configuar o scaling do NodeGroup"
  type        = map(string)
  default = {
    "min_size" : "2",
    "max_size" : "4",
    "desired_size" : "2"
  }
}
variable "cluster_sg" {
  description = "Utilizada para acrescentar novas regras ao security group do cluster EKS"

  type = list(object({
    cidr_blocks = list(string)
    from_port   = number
    to_port     = number
    protocol    = string
    description = string
    type        = string
  }))

  default = [
    {
      cidr_blocks = [""]
      from_port   = ""
      to_port     = ""
      protocol    = ""
      description = ""
      type        = ""
    }
    ]
}
