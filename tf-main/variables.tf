variable "region" {
  description = "Region"
  type        = string
  default     = "ap-northeast-2"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "cluster_name" {
  description = "EKS Cluster Name"
  type        = string
  default     = "my-cluster"
}

variable "node_group_desired_size" {
  description = "Desired size of the node group"
  type        = number
  default     = 2
}

variable "node_group_min_size" {
  description = "Minimum size of the node group"
  type        = number
  default     = 1
}

variable "node_group_max_size" {
  description = "Maximum size of the node group"
  type        = number
  default     = 3
}

variable "service_account_name" {
  description = "EKS ServiceAccount Name"
  type        = string
  default     = "eks-sa"
}

variable "app_namespace" {
  description = "EKS namespace"
  type        = string
  default     = "app"
}

variable "dynamodb_table_name" {
  description = "DynamoDB table_name"
  type        = string
  default     = "my-dynamo-table"
}

variable "hash_key" {
  description = "The hash key for the DynamoDB table"
  type        = string
  default     = "id"
}

variable "table_attributes" {
  description = "Attributes for the DynamoDB table"
  type        = list(object({
    name = string
    type = string
  }))
  default = []
}

variable "bucket_name" {
  description = "The name of the S3 bucket"
  type        = string
  default     = "video-bucket"
}

# namespace 변수 정의
variable "argocd_namespace" {
  description = "Namespace where ArgoCD will be installed"
  type        = string
  default     = "argocd"
}