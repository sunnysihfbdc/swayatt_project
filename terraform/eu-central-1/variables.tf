# Base and sample variables

variable "region" {
  description = "The AWS region where all terraform operations are carried out."
  type        = string
  default     = "eu-central-1"
}

variable "tags" {
  description = "Tags for all resources"
  type        = map(string)
}

variable "compute_vpc_name" {
  type        = string
  description = "Name of the Compute VPC"
}

variable "compute_vpc_cidr" {
  type        = string
  description = "IP CIDR Range of the Compute VPC"
}

variable "create_eks_cluster" {
  description = "Flag to enable / disable the cluster creation"
  type        = bool
  default     = false
}

variable "eks_cluster_name" {
  type        = string
  description = "Name of the EKS cluster"
}

variable "eks_node_group_name" {
  type        = string
  description = "Name of the EKS cluster Node group"
}

variable "service_worker_node_group_instance_type" {
  type        = string
  description = "Instance Type of the Node Group"
}

variable "eks_cluster_version" {
  type        = string
  description = "Kubernetes cluster version"
  default     = "1.22"
}

variable "eks_cluster_iam_role_name" {
  type        = string
  description = "Name of the EkS Cluster IAM Role"
}

variable "eks_cluster_node_group_role_name" {
  type        = string
  description = "Name of the EkS Cluster Node Group IAM Role"
}

variable "bastion_host_instance_profile_name" {
  description = "Name of the Bastion Host Instance Profile"
  type        = string
}

variable "bastion_host_role_name" {
  description = "Name of the Bastion Host IAM Role"
  type        = string
}

variable "eks_node_group_desired_size" {
  description = "Desired Number of Nodes in the EKS Node Group"
  type        = string
}

variable "eks_node_group_max_size" {
  description = "Maximum Number of Nodes in the EKS Node Group"
  type        = string
}

variable "eks_node_group_min_size" {
  description = "Minimum Number of Nodes in the EKS Node Group"
  type        = string
  default     = "1"
}

variable "swayatt_ecr_repo_name" {
  description = "Name of the swayatt ECR Repo"
  type        = string
}