variable "region" {
  description = "Region"
  type        = string
}

variable "cluster_name" {
  description = "The name of the EKS cluster"
  type        = string
}

variable "vpc_id" {
  description = "The VPC ID where the EKS cluster will be created"
  type        = string
}

variable "public_subnet_ids" {
  description = "List of subnet IDs for the EKS cluster"
  type        = list(string)
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs for the EKS node group"
  type        = list(string)
}

variable "node_group_desired_size" {
  description = "The desired size of the node group"
  type        = number
}

variable "node_group_min_size" {
  description = "The minimum size of the node group"
  type        = number
}

variable "node_group_max_size" {
  description = "The maximum size of the node group"
  type        = number
}

