
##################################################################################
# Data definitions
##################################################################################

data "aws_availability_zones" "available" {}

data "aws_caller_identity" "current" {}

# data "aws_eks_cluster" "app_eks_cluster" {
#   name = var.eks_cluster_name
# }
