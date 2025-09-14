# swayatt_project

Key Components

🔹 VPC & Networking

Custom VPC with CIDR (defined via variable compute_vpc_cidr)

Public subnets for ALB & Bastion

Private subnets for EC2 / EKS nodes

🔹 Application Load Balancer (ALB)

Publicly accessible endpoint

Routes traffic into private nodes securely

Improves fault tolerance

🔹 Bastion Host

Deployed in a public subnet

Has IAM role & instance profile (bastion_host_role_name, bastion_host_instance_profile_name)

Provides secure SSH jump access into private nodes

🔹 EKS Cluster (Optional)

Created only if create_eks_cluster = true

Supports Kubernetes workloads

Node groups configurable with min/max/desired size

🔹 ECR (Elastic Container Registry)

Stores container images (swayatt_ecr_repo_name)

Used by private EC2/EKS nodes
