# Terraform AWS EKS Thanos Cluster

## Introdução

Este projeto Terraform provisiona um cluster Amazon EKS (Elastic Kubernetes Service) na AWS, com o Karpenter para gerenciamento automático de nós. A configuração é otimizada para a execução de cargas de trabalho do Thanos mode :), garantindo alta disponibilidade e escalabilidade.

## Arquitetura

A arquitetura deste cluster EKS foi projetada para ser robusta, segura e econômica. Abaixo estão os principais componentes da arquitetura:

- **Cluster EKS:** O coração da nossa infraestrutura, orquestrando nossos contêineres.
- **Karpenter:** Para o gerenciamento de nós, o Karpenter é utilizado em vez do Auto Scaling Group tradicional. O Karpenter provisiona e desprovisiona nós de forma mais eficiente, respondendo diretamente às necessidades de agendamento de pods do Kubernetes.
- **NodePools e EC2NodeClass:** O Karpenter é configurado com `NodePools` para instâncias on-demand e spot, permitindo uma otimização de custos. A `EC2NodeClass` define a configuração base para os nós, como AMIs e tipos de instância.
- **Fargate:** O namespace do Karpenter é executado em um perfil Fargate, eliminando a necessidade de gerenciar nós para o próprio Karpenter.
- **IAM Roles for Service Accounts (IRSA):** As permissões da AWS são concedidas aos pods do Kubernetes de forma segura, associando papéis do IAM a contas de serviço do Kubernetes.
- **Addons do EKS:** O cluster é provisionado com os addons essenciais do EKS, como VPC CNI, CoreDNS, Kube-proxy e o EBS CSI Driver.

## Recursos Implementados

Este módulo Terraform cria os seguintes recursos na AWS:

- **Amazon EKS Cluster:** O cluster Kubernetes gerenciado.
- **Amazon EKS Addons:**
    - `vpc-cni`: Para a rede de pods.
    - `coredns`: Para a resolução de nomes no cluster.
    - `kube-proxy`: Para o balanceamento de carga de rede.
    - `aws-ebs-csi-driver`: Para o gerenciamento de volumes EBS.
- **AWS Fargate Profile:** Para executar os pods do Karpenter.
- **IAM Roles and Policies:** Papéis e políticas do IAM para o cluster EKS, Karpenter e nós de trabalho.
- **Amazon SQS Queue:** Uma fila SQS para o Karpenter gerenciar interrupções de instâncias spot.
- **Helm Release for Karpenter:** Instalação do Karpenter no cluster via Helm.
- **Recursos Customizados do Karpenter:**
    - `EC2NodeClass`: Para definir a configuração dos nós.
    - `NodePool`: Para gerenciar os conjuntos de nós.

## Pré-requisitos

Antes de começar, certifique-se de ter os seguintes pré-requisitos instalados e configurados:

- [Terraform](https://learn.hashicorp.com/tutorials/terraform/install-cli)
- [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-install.html)
- [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/)
- [Helm](https://helm.sh/docs/intro/install/)

## Como Usar

Siga os passos abaixo para provisionar o cluster EKS:

1. **Clone este repositório:**
   ```bash
   git clone <URL_DO_REPOSITORIO>
   cd <NOME_DO_REPOSITORIO>
   ```

2. **Configure as variáveis:**
   - Renomeie o arquivo `terraform.tfvars.example` para `terraform.tfvars`.
   - Altere os valores das variáveis no arquivo `terraform.tfvars` de acordo com as suas necessidades.

3. **Inicialize o Terraform:**
   ```bash
   terraform init
   ```

4. **Planeje as alterações:**
   ```bash
   terraform plan
   ```

5. **Aplique as alterações:**
   ```bash
   terraform apply
   ```

6. **Configure o kubectl:**
   Após a criação do cluster, configure o `kubectl` para se conectar a ele:
   ```bash
   aws eks update-kubeconfig --region <SUA_REGIAO> --name <NOME_DO_CLUSTER>
   ```

7. **Verifique a instalação do Karpenter:**
   ```bash
   kubectl get pods -n karpenter
   ```

## Variáveis de Entrada

Abaixo estão as variáveis de entrada mais importantes. Para uma lista completa, consulte o arquivo `variables.tf`.

| Nome | Descrição | Tipo | Padrão |
|------|-----------|------|--------|
| `project_name` | O nome do projeto, usado para nomear os recursos. | `string` | `"eks-thanos"` |
| `aws_region` | A região da AWS onde os recursos serão criados. | `string` | `"us-east-1"` |
| `karpenter_version` | A versão do Karpenter a ser instalada. | `string` | `"v0.32.1"` |
| `nodepool_instance_families` | As famílias de instâncias a serem usadas pelo Karpenter. | `list(string)` | `["t3", "m5", "c5"]` |
| `nodepool_instance_sizes` | Os tamanhos de instâncias a serem usadas pelo Karpenter. | `list(string)` | `["medium", "large", "xlarge"]` |

## Saídas

Este módulo produz as seguintes saídas:

| Nome | Descrição |
|------|-----------|
| `eks_cluster_id` | O ID do cluster EKS. |
| `eks_cluster_endpoint` | O endpoint do cluster EKS. |
| `eks_cluster_version` | A versão do Kubernetes do cluster EKS. |
| `karpenter_iam_role_arn` | O ARN do papel do IAM do Karpenter. |
