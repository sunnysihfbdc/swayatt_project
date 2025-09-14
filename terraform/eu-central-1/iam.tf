module "eks_cluster_iam_role" {
  source             = "../modules/iam"
  role_name          = var.eks_cluster_iam_role_name
  description        = "IAM Role for Application EKS Cluster"
  assume_role_policy = data.aws_iam_policy_document.eks_cluster_trust_policy.json
  managed_iam_policies = [
    "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy",
    "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
  ]
  tags = merge(
    { "Name" = var.eks_cluster_iam_role_name },
    var.tags
  )
}

data "aws_iam_policy_document" "eks_cluster_trust_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["eks.amazonaws.com"]
    }

    condition {
      test     = "StringEquals"
      variable = "aws:SourceArn"
      values   = ["arn:aws:eks:${var.region}:${data.aws_caller_identity.current.account_id}:cluster/${var.eks_cluster_name}"]
    }
  }
}

module "eks_cluster_node_group_iam_role" {
  source             = "../modules/iam"
  role_name          = var.eks_cluster_node_group_role_name
  description        = "IAM Role for Application EKS Cluster Node Group"
  assume_role_policy = data.aws_iam_policy_document.eks_node_group_trust_policy.json
  managed_iam_policies = [
    "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy",
    "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly",
    "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy",
    "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore",
    "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
  ]
  tags = merge(
    { "Name" = var.eks_cluster_iam_role_name },
    var.tags
  )
}

data "aws_iam_policy_document" "eks_node_group_trust_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }

  }
}

module "bastion_host_iam_role" {
  source             = "../modules/iam"
  role_name          = var.bastion_host_role_name
  description        = "IAM Role for Bastion Host"
  assume_role_policy = data.aws_iam_policy_document.bastion_host_trust_policy.json
  managed_iam_policies = [
    "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore",
  ]
  custom_iam_policies = [{
    name            = "bastion-host-${var.eks_cluster_name}-policy"
    description     = "IAM Policy for Bastion Host to perform operations on Application Cluster"
    policy_document = data.aws_iam_policy_document.bastion_host_eks_cluster_policy_document.json
    }
  ]

  tags = merge(
    { "Name" = var.bastion_host_role_name },
    var.tags
  )
}

data "aws_iam_policy_document" "bastion_host_trust_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "bastion_host_eks_cluster_policy_document" {
  statement {
    effect = "Allow"

    actions = [
      "eks:DescribeCluster"
    ]

    resources = [
      "arn:aws:eks:${var.region}:${data.aws_caller_identity.current.account_id}:cluster/${var.eks_cluster_name}"
    ]
  }

  statement {
    effect = "Allow"

    actions = [
      "eks:ListClusters",
      "eks:AccessKubernetesApi"
    ]

    resources = ["*"]
  }
}

resource "aws_iam_instance_profile" "bastion_host_iam_instance_profile" {
  name = var.bastion_host_instance_profile_name
  role = module.bastion_host_iam_role.iam_role_name
}

resource "aws_iam_openid_connect_provider" "eks_oidc_provider" {
  client_id_list = ["sts.amazonaws.com"]
  url = module.app_eks_cluster.oidc_issuer
  # url            = data.aws_eks_cluster.app_eks_cluster.identity[0].oidc[0].issuer

  tags = merge(
    { "Name" = "eks-oidc-provider" },
    var.tags
  )
}


