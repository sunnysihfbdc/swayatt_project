resource "aws_security_group" "app_eks_cluster_sg" {
  name        = "${var.eks_cluster_name}-security-group"
  description = "Allow HTTPS Access from Bastion Host"
  vpc_id      = module.compute_vpc.vpc_id

  ingress {
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    security_groups = [aws_security_group.bastion_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    { "Name" = "${var.eks_cluster_name}-security-group" },
    var.tags
  )
}

module "app_eks_cluster" {
  source              = "../modules/eks"
  eks_cluster_name    = var.eks_cluster_name
  eks_role_arn        = module.eks_cluster_iam_role.iam_role_arn
  eks_cluster_version = var.eks_cluster_version
  eks_tags = merge(
    { "Name" = var.eks_cluster_name },
    var.tags
  )
  eks_subnet_ids         = module.compute_vpc.private_subnets
  eks_security_group_ids = [aws_security_group.app_eks_cluster_sg.id]
}

module "app_eks_cluster_node_group" {
  source                              = "../modules/eks/node-groups"
  eks_cluster_name                    = var.eks_cluster_name
  eks_node_group_eks_cluster_name     = module.app_eks_cluster.cluster_name
  eks_node_group_name                 = var.eks_node_group_name
  eks_region                          = var.region
  eks_node_group_launch_template_name = "${var.eks_node_group_name}-launch-template"
  eks_node_group_ssh_key              = "${var.eks_node_group_name}-key"
  eks_node_role_arn                   = module.eks_cluster_node_group_iam_role.iam_role_arn
  eks_node_group_subnet_ids           = module.compute_vpc.private_subnets
  eks_node_group_desired_size         = var.eks_node_group_desired_size
  eks_node_group_max_size             = var.eks_node_group_max_size
  eks_node_group_min_size             = var.eks_node_group_min_size
  eks_node_group_instance_type        = [var.service_worker_node_group_instance_type]
  eks_node_group_tags = merge(
    { "Name" = var.eks_cluster_name },
    var.tags
  )
  eks_node_group_labels = {
    "cluster-name" = var.eks_cluster_name
  }
}

data "aws_eks_addon_version" "vpc_cni_version" {
  addon_name         = "vpc-cni"
  kubernetes_version = module.app_eks_cluster.cluster_version
  most_recent        = true
}

resource "aws_eks_addon" "vpc_cni" {
  cluster_name  = module.app_eks_cluster.cluster_name
  addon_name    = "vpc-cni"
  addon_version = data.aws_eks_addon_version.vpc_cni_version.version
}

data "aws_eks_addon_version" "coredns_version" {
  addon_name         = "coredns"
  kubernetes_version = module.app_eks_cluster.cluster_version
  most_recent        = true
}

resource "aws_eks_addon" "coredns" {
  cluster_name  = module.app_eks_cluster.cluster_name
  addon_name    = "coredns"
  addon_version = data.aws_eks_addon_version.coredns_version.version
}

data "aws_eks_addon_version" "kube_proxy_version" {
  addon_name         = "kube-proxy"
  kubernetes_version = module.app_eks_cluster.cluster_version
  most_recent        = true
}

resource "aws_eks_addon" "kube_proxy" {
  cluster_name  = module.app_eks_cluster.cluster_name
  addon_name    = "kube-proxy"
  addon_version = data.aws_eks_addon_version.kube_proxy_version.version
}
