module "compute_vpc" {
  source             = "../modules/vpc"
  name               = var.compute_vpc_name
  cidr               = var.compute_vpc_cidr
  enable_s3_endpoint = true
  enable_nat_gateway = true
  azs                = data.aws_availability_zones.available.names
  tags = merge(
    { "Name" = var.compute_vpc_name },
    var.tags
  )
}
