# Terraform AWS EKS Thanos Cluster

Este módulo do Terraform provisiona um cluster Amazon EKS (Elastic Kubernetes Service) na AWS. Ele é projetado para ser flexível e pode ser usado com ou sem um módulo VPC pré-existente.

## Funcionalidades

- Criação de um cluster EKS.
- Configuração de um Node Group inicial.
- Instalação de addons essenciais do EKS:
  - `vpc-cni`
  - `coredns`
  - `kube-proxy`
  - `eks-pod-identity-agent`
  - `metrics-server`
  - `aws-efs-csi-driver`
- Configuração de regras de Security Group para o cluster.
- Armazenamento do nome do cluster no AWS Systems Manager Parameter Store.

## Como usar

### Pré-requisitos

- Terraform v1.0.0 ou superior.
- Credenciais da AWS configuradas.

### Exemplo de uso

```terraform
module "eks_cluster" {
  source = "./"

  project_name = "meu-projeto-eks"
  region       = "us-east-1"

  # Versão do cluster EKS
  cluster_version = "1.28"

  # Configurações de acesso ao endpoint da API do EKS
  endpoint_public_access  = true
  endpoint_private_access = true

  # Versões dos addons do EKS
  vpc_cni_version        = "v1.15.0-eksbuild.1"
  coredns_version        = "v1.11.1-eksbuild.4"
  kube_proxy             = "v1.28.2-eksbuild.2"
  eks_pod_identity_agent = "v1.2.0-eksbuild.1"
  metrics_server         = "v0.6.4-eksbuild.1"
  addon_efs_csi_version  = "v1.5.8-eksbuild.1"

  # Configurações do Node Group
  nodegroup_instance_types = ["t3.medium"]
  ami_type                 = "AL2_x86_64"
  disk_size                = "50"
}
```

### Integração com o módulo VPC da SolidStack

Este módulo pode ser integrado com o módulo VPC da SolidStack. Para isso, defina a variável `solidstack_vpc_module` como `true`. O módulo irá buscar as informações da VPC (ID da VPC, subnets, etc.) no AWS Systems Manager Parameter Store. Certifique-se de que o `project_name` seja o mesmo em ambos os módulos.

Se `solidstack_vpc_module` for `false`, você precisará fornecer as informações da VPC manualmente através das variáveis `public_subnets`, `pods_subnets`, `privates_subnets` e `vpc_cidr`.

## Variáveis

| Nome                       | Descrição                                                                                                                | Tipo           | Padrão                | Obrigatório |
| -------------------------- | ------------------------------------------------------------------------------------------------------------------------ | -------------- | --------------------- | ----------- |
| `region`                   | Região onde os recursos serão construídos.                                                                               | `string`       | -                     | sim         |
| `project_name`             | Nome do projeto.                                                                                                         | `string`       | -                     | sim         |
| `solidstack_vpc_module`    | Se `true`, o módulo usará os recursos criados pelo módulo VPC da SolidStack.                                             | `bool`         | `true`                | não         |
| `public_subnets`           | Lista de IDs das subnets públicas. Usado apenas se `solidstack_vpc_module` for `false`.                                  | `list(string)` | `[]`                  | não         |
| `pods_subnets`             | Lista de IDs das subnets de pods. Usado apenas se `solidstack_vpc_module` for `false`.                                   | `list(string)` | `[]`                  | não         |
| `privates_subnets`         | Lista de IDs das subnets privadas. Usado apenas se `solidstack_vpc_module` for `false`.                                  | `list(string)` | `[]`                  | não         |
| `vpc_cidr`                 | Bloco CIDR da VPC. Usado para a regra de entrada do security group. Usado apenas se `solidstack_vpc_module` for `false`. | `string`       | `""`                  | não         |
| `cluster_version`          | Versão do cluster EKS desejada.                                                                                          | `string`       | -                     | sim         |
| `endpoint_public_access`   | Deseja habilitar o acesso público a API do cluster?                                                                      | `bool`         | `true`                | não         |
| `endpoint_private_access`  | Deseja habilitar o acesso privado a API do cluster?                                                                      | `bool`         | `true`                | não         |
| `vpc_cni_version`          | Versão desejada do addon VPC-CNI.                                                                                        | `string`       | -                     | sim         |
| `coredns_version`          | Versão desejada do addon CoreDNS.                                                                                        | `string`       | -                     | sim         |
| `addon_efs_csi_version`    | Versão desejada do addon aws-efs-csi-driver.                                                                             | `string`       | -                     | sim         |
| `kube_proxy`               | Versão desejada do addon Kube-Proxy.                                                                                     | `string`       | -                     | sim         |
| `eks_pod_identity_agent`   | Versão desejada do addon EKS-Pod-Identity-Agent.                                                                         | `string`       | -                     | sim         |
| `metrics_server`           | Versão desejada do addon Metrics-Server.                                                                                 | `string`       | -                     | sim         |
| `nodegroup_instance_types` | Tipos de instâncias do NodeGroup.                                                                                        | `list(string)` | `["c6i.large"]`       | não         |
| `ami_type`                 | AMI id utilizado pelo NodeGroup.                                                                                         | `string`       | `BOTTLEROCKET_x86_64` | não         |
| `disk_size`                | Tamanho do disco das instâncias do NodeGroup.                                                                            | `string`       | `100`                 | não         |
| `tags`                     | Tags a serem aplicadas nos recursos.                                                                                     | `map(string)`  | `{}`                  | não         |

## Outputs

| Nome           | Descrição              |
| -------------- | ---------------------- |
| `cluster_name` | O nome do cluster EKS. |
