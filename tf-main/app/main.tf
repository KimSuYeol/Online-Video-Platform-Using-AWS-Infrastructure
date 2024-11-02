# AWS 계정 정보 가져오기
data "aws_caller_identity" "current" {}

# IAM Role 및 Policy 생성
data "aws_iam_policy_document" "alb_controller_assume_role_policy" {
  statement {
    effect = "Allow"

    principals {
      type        = "Federated"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/${var.eks_oidc_url}"]
    }

    actions = ["sts:AssumeRoleWithWebIdentity"]

    condition {
      test     = "StringEquals"
      variable = "${var.eks_oidc_url}:sub"
      values   = ["system:serviceaccount:kube-system:aws-load-balancer-controller"]
    }
  }
}

# IAM 역할 생성
resource "aws_iam_role" "alb_controller_role" {
  name               = "eks-alb-controller-role"
  assume_role_policy = data.aws_iam_policy_document.alb_controller_assume_role_policy.json
}

# AWS Load Balancer Controller에 필요한 정책 연결
resource "aws_iam_role_policy_attachment" "alb_controller_policy_attachment" {
  role       = aws_iam_role.alb_controller_role.name
  policy_arn = "arn:aws:iam::aws:policy/ElasticLoadBalancingFullAccess"
}


# AWS Load Balancer Controller용 ServiceAccount 생성
resource "kubernetes_service_account" "alb_controller_sa" {
  metadata {
    name      = "aws-load-balancer-controller"
    namespace = "kube-system"
    annotations = {
      "eks.amazonaws.com/role-arn" = aws_iam_role.alb_controller_role.arn
    }
  }
}


# Helm provider 설정
# provider "helm" {
#   kubernetes {
#     host                   = module.eks.cluster_endpoint
#     cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
#     token                  = data.aws_eks_cluster_auth.main.token
#   }
# }

# AWS Load Balancer Controller Helm Chart 배포
resource "helm_release" "aws_load_balancer_controller" {
  name       = "aws-load-balancer-controller"
  chart      = "aws-load-balancer-controller"
  repository = "https://aws.github.io/eks-charts"
  namespace  = "kube-system"

  values = [
    <<EOF
clusterName: ${var.cluster_name}
serviceAccount:
  create: false
  name: aws-load-balancer-controller
EOF
  ]
}
