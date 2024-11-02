variable "region" {
  description = "Region"
  type        = string
}

variable "cluster_name" {
  description = "The name of the EKS cluster"
  type        = string
}

# namespace 변수 정의
variable "argocd_namespace" {
  description = "Namespace where ArgoCD will be installed"
  type        = string
  default     = "argocd"
}

variable "service_account_name" {
  description = "EKS ServiceAccount Name"
  type        = string
}

variable "dynamodb_table_name" {
  description = "DynamoDB table_name"
  type        = string
}

variable "bucket_name" {
  description = "The name of the S3 bucket"
  type        = string
}

variable "eks_oidc_url" {
  description = "The name of the S3 bucket"
  type        = string
}


