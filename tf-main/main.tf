provider "aws" {
  region = var.region
}

module "network" {
  source   = "./network"
  vpc_cidr = var.vpc_cidr
}

module "dynamodb" {
  source   = "./dynamodb"
  dynamodb_table_name = var.dynamodb_table_name
  hash_key = var.hash_key
  table_attributes = var.table_attributes
}

module "s3" {
  source   = "./s3"
  bucket_name = var.bucket_name
}

module "eks" {
  source              = "./eks"
  region = var.region
  cluster_name       = var.cluster_name
  vpc_id             = module.network.vpc_id                # VPC ID
  public_subnet_ids         = module.network.public_subnet_ids    # Public subnet IDs
  private_subnet_ids         = module.network.private_subnet_ids    # Private subnet IDs
  node_group_desired_size = var.node_group_desired_size
  node_group_min_size     = var.node_group_min_size
  node_group_max_size     = var.node_group_max_size

}

# Helm으로 AWS Load Balancer Controller 설치
provider "kubernetes" {
  host                   = module.eks.cluster_endpoint  # 엔드포인트
  cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority)  # CA 인증서
  token                  = module.eks.cluster_token  # 인증 토큰
}

provider "helm" {
  kubernetes {
    host                   = module.eks.cluster_endpoint  # 엔드포인트
    cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority)  # CA 인증서
    token                  = module.eks.cluster_token  # 인증 토큰
  }
}

module "helm_app" {
  source   = "./app"
  cluster_name       = var.cluster_name
  argocd_namespace  = var.argocd_namespace

  service_account_name = var.service_account_name
  # IAM 역할 및 IRSA 생성
  region = var.region
  eks_oidc_url = module.eks.eks_oidc_url
  dynamodb_table_name   =   var.dynamodb_table_name
  bucket_name   =   var.bucket_name

}