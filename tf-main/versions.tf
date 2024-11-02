terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0.0"  # 5.0.0 이상으로 설정
    }
  }
  required_version = ">= 1.0"
}
