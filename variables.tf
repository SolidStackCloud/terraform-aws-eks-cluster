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

variable "cluster_log_types" {
  description = "Variável utilizada para especificar quais tipos de logs serão habilitados no cluster EKS"
  default = ["api", "audit", "authenticator", "controllerManager", "scheduler"]
  type = list(string)
}

variable "authentication_mode" {
  description = "Determina o tipo de autenticação permitido no cluster EKS"
  default = "API_AND_CONFIG_MAP"
  type = string
}


### NODE GROUP

variable "disk_size" {
  description = "Determina o tamanho do disco do Node"
  default = "100"
  type = string
}

variable "ami_type" {
  description = "Determina o time de sistema operacional utilizado pelo nodes."
  default = "BOTTLEROCKET_x86_64"
  type = string
}

variable "instance_types" {
  description = "Famílias de instâncias a serem usadas pelos nodes."
  default = ["c6i.large"]
  type = list(string)
}

variable "scaling_config" {
  description = "Utilizada para configurar o autoscaling do node group."
  default = {
    desired_size = 1
    max_size     = 2
    min_size     = 1
  }
  type = object({
    desired_size = number
    max_size     = number
    min_size     = number
  })
}


variable "add_rule_cluster_security_group" {
  
  type = map(object({
      cidr_blocks       = list(string)
      from_port         = number
      to_port           = number
      protocol          = string
      description       = string
  }))
  
  default = {
    "NodePort" = {
      cidr_blocks       = ["0.0.0.0/0"]
      from_port         = 30000
      to_port           = 32768
      protocol          = "tcp"
      description       = "Nodeports"
      type              = "ingress"
    }
    "CoreDNS" = {
      cidr_blocks       = ["0.0.0.0/0"]
      from_port         = 53
      to_port           = 53
      protocol          = "udp"
      description       = "CoreDNS"
    }
    "CoreDNS" = {
      cidr_blocks       = ["0.0.0.0/0"]
      from_port         = 53
      to_port           = 53
      protocol          = "tcp"
      description       = "CoreDNS"
    }
  }
  
  
}