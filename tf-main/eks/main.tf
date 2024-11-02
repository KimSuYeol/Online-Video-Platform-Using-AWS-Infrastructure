############################################ EKS Cluster 및 IAM 역할 생성 ##########################################################


# IAM 역할에 권한을 부여하는 정책 문서 생성
data "aws_iam_policy_document" "eks_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]
    
    principals {
      type        = "Service"
      identifiers = ["eks.amazonaws.com"]
    }
  }
}


# IAM 역할 생성
resource "aws_iam_role" "eks_cluster_role" {
  name               = "${var.cluster_name}-eks-cluster-role"
  assume_role_policy = data.aws_iam_policy_document.eks_assume_role_policy.json
}


# 정책 생성 (Create, Describe, Update, Delete 권한 부여)
resource "aws_iam_policy" "eks_cluster_policy" {
  name        = "${var.cluster_name}-eks-cluster-policy"
  description = "Policy for EKS cluster to allow create, describe, update, and delete operations."

  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "autoscaling:DescribeAutoScalingGroups",
                "autoscaling:UpdateAutoScalingGroup",
                "ec2:AttachVolume",
                "ec2:AuthorizeSecurityGroupIngress",
                "ec2:CreateRoute",
                "ec2:CreateSecurityGroup",
                "ec2:CreateTags",
                "ec2:CreateVolume",
                "ec2:DeleteRoute",
                "ec2:DeleteSecurityGroup",
                "ec2:DeleteVolume",
                "ec2:DescribeInstances",
                "ec2:DescribeRouteTables",
                "ec2:DescribeSecurityGroups",
                "ec2:DescribeSubnets",
                "ec2:DescribeVolumes",
                "ec2:DescribeVolumesModifications",
                "ec2:DescribeVpcs",
                "ec2:DescribeDhcpOptions",
                "ec2:DescribeNetworkInterfaces",
                "ec2:DescribeAvailabilityZones",
                "ec2:DetachVolume",
                "ec2:ModifyInstanceAttribute",
                "ec2:ModifyVolume",
                "ec2:RevokeSecurityGroupIngress",
                "ec2:DescribeAccountAttributes",
                "ec2:DescribeAddresses",
                "ec2:DescribeInternetGateways",
                "elasticloadbalancing:AddTags",
                "elasticloadbalancing:ApplySecurityGroupsToLoadBalancer",
                "elasticloadbalancing:AttachLoadBalancerToSubnets",
                "elasticloadbalancing:ConfigureHealthCheck",
                "elasticloadbalancing:CreateListener",
                "elasticloadbalancing:CreateLoadBalancer",
                "elasticloadbalancing:CreateLoadBalancerListeners",
                "elasticloadbalancing:CreateLoadBalancerPolicy",
                "elasticloadbalancing:CreateTargetGroup",
                "elasticloadbalancing:DeleteListener",
                "elasticloadbalancing:DeleteLoadBalancer",
                "elasticloadbalancing:DeleteLoadBalancerListeners",
                "elasticloadbalancing:DeleteTargetGroup",
                "elasticloadbalancing:DeregisterInstancesFromLoadBalancer",
                "elasticloadbalancing:DeregisterTargets",
                "elasticloadbalancing:DescribeListeners",
                "elasticloadbalancing:DescribeLoadBalancerAttributes",
                "elasticloadbalancing:DescribeLoadBalancerPolicies",
                "elasticloadbalancing:DescribeLoadBalancers",
                "elasticloadbalancing:DescribeTargetGroupAttributes",
                "elasticloadbalancing:DescribeTargetGroups",
                "elasticloadbalancing:DescribeTargetHealth",
                "elasticloadbalancing:DetachLoadBalancerFromSubnets",
                "elasticloadbalancing:ModifyListener",
                "elasticloadbalancing:ModifyLoadBalancerAttributes",
                "elasticloadbalancing:ModifyTargetGroup",
                "elasticloadbalancing:ModifyTargetGroupAttributes",
                "elasticloadbalancing:RegisterInstancesWithLoadBalancer",
                "elasticloadbalancing:RegisterTargets",
                "elasticloadbalancing:SetLoadBalancerPoliciesForBackendServer",
                "elasticloadbalancing:SetLoadBalancerPoliciesOfListener",
                "kms:DescribeKey"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": "iam:CreateServiceLinkedRole",
            "Resource": "*",
            "Condition": {
                "StringEquals": {
                    "iam:AWSServiceName": "elasticloadbalancing.amazonaws.com"
                }
            }
        }
    ]
})
}

# 역할에 정책 연결
resource "aws_iam_role_policy_attachment" "eks_cluster_policy_attachment" {
  policy_arn = aws_iam_policy.eks_cluster_policy.arn
  role       = aws_iam_role.eks_cluster_role.name
}

# EKS 클러스터 생성
resource "aws_eks_cluster" "this" {
  name     = var.cluster_name
  role_arn = aws_iam_role.eks_cluster_role.arn

  vpc_config {
    subnet_ids = var.public_subnet_ids
  }
}

############################################ OIDC 공급자 생성 ##########################################################

# OIDC 공급자를 위한 데이터 소스
data "aws_eks_cluster" "cluster" {
  name = aws_eks_cluster.this.name
}



# OIDC 공급자 생성
# resource "aws_iam_openid_connect_provider" "eks_oidc_provider" {
#   client_id_list = ["sts.amazonaws.com"]
#   url            = data.aws_eks_cluster.cluster.identity[0].oidc[0].issuer
#   thumbprint_list = [data.aws_eks_cluster.cluster.identity[0].oidc[0].issuer]
# }


############################################ EKS 노드 그룹 및 IAM 역할 생성 ##########################################################

# IAM 역할 생성
resource "aws_iam_role" "eks_node_group_role" {
  name               = "${var.cluster_name}-eks-node-group-role"
  assume_role_policy = data.aws_iam_policy_document.eks_node_assume_role_policy.json
}

# IAM 역할에 노드 그룹 정책 부여 (AmazonEKS_CNI_Policy, AmazonEKSWorkerNodePolicy, AmazonEC2ContainerRegistryReadOnly)
data "aws_iam_policy_document" "eks_node_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "cni_policy_attachment" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.eks_node_group_role.name
}

resource "aws_iam_role_policy_attachment" "worker_node_policy_attachment" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.eks_node_group_role.name
}

resource "aws_iam_role_policy_attachment" "ecr_readonly_policy_attachment" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.eks_node_group_role.name
}

# EKS 노드 그룹 생성 - privaate
resource "aws_eks_node_group" "eks_private_node_group" {
  cluster_name    = aws_eks_cluster.this.name
  node_group_name = "${var.cluster_name}-private-node-group"
  node_role_arn   = aws_iam_role.eks_node_group_role.arn
  subnet_ids      = var.private_subnet_ids

  scaling_config {
    desired_size = var.node_group_desired_size
    max_size     = var.node_group_max_size
    min_size     = var.node_group_min_size
  }

  instance_types = ["c5.large"]

  depends_on = [aws_eks_cluster.this]
}

# EKS 노드 그룹 생성 - public
resource "aws_eks_node_group" "eks_public_node_group" {
  cluster_name    = aws_eks_cluster.this.name
  node_group_name = "${var.cluster_name}-public-node-group"
  node_role_arn   = aws_iam_role.eks_node_group_role.arn
  subnet_ids      = var.public_subnet_ids

  scaling_config {
    desired_size = var.node_group_desired_size
    max_size     = var.node_group_max_size
    min_size     = var.node_group_min_size
  }

  instance_types = ["c5.large"]

  depends_on = [aws_eks_cluster.this]
}


############################################ output ##########################################################

data "aws_eks_cluster_auth" "this" {
  name = aws_eks_cluster.this.name  # EKS 클러스터 이름을 참조
}

output "cluster_endpoint" {
  value = aws_eks_cluster.this.endpoint  # EKS 클러스터의 엔드포인트
}

output "cluster_token" {
  value = data.aws_eks_cluster_auth.this.token  # EKS 클러스터의 인증 토큰
}

output "cluster_certificate_authority" {
  value = aws_eks_cluster.this.certificate_authority[0].data  # CA 인증서
}

# OIDC URL 출력
output "eks_oidc_url" {
  value = element(split("/", data.aws_eks_cluster.cluster.identity[0].oidc[0].issuer), length(split("/", data.aws_eks_cluster.cluster.identity[0].oidc[0].issuer)) - 1)
  description = "The OIDC URL for the EKS cluster"
}