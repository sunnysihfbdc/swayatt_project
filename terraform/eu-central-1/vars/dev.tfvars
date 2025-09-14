###################################################
# environment specific value assignment to variables
###################################################

### Sample variables

tags = {
  "Organisation"        = "Swayatt Drishtigochar"
  "Environment"  = "development"
  "AWSRegion"    = "Frankfurt"
}

create_eks_cluster                          = true
eks_cluster_version                         = "1.31"
compute_vpc_name                            = "compute-vpc"
compute_vpc_cidr                            = "10.0.0.0/16"
eks_cluster_name                            = "app-eks-cluster"
service_worker_node_group_instance_type     = "t3.micro"
eks_node_group_name                         = "app-eks-cluster-node-group"
eks_cluster_iam_role_name                   = "app-eks-cluster-role"
eks_cluster_node_group_role_name            = "app-eks-cluster-node-group-role"
bastion_host_instance_profile_name          = "bastion-host-iam-instance-profile"
bastion_host_role_name                      = "bastion-host-role"
eks_node_group_desired_size                 = "1"
eks_node_group_max_size                     = "3"
eks_node_group_min_size                     = "1"
swayatt_ecr_repo_name                        = "swayatt-ecr-repo"

