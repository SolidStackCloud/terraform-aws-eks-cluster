variable "region" {
  description = "Região onde os recursos serão construídos"
  type = string
}
variable "project_name" {
  description = "Nome do projeto"
  type = string
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
  type = string
}

variable "endpoint_public_access" {
  description = "Deseja habilitar o acesso público a API do cluster?"
  type = bool
  default = true
}

variable "endpoint_private_access" {
  description = "Deseja habilitar o acesso privado a API do cluster?"
  type = bool
  default = true
}



############################ ADDONS

variable "vpc_cni_version" {
  description = "Versão desejada do addon VPC-CNI"
  type = string
}