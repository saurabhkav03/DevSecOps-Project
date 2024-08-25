resource "random_string" "random" {
  length  = 8
  special = false
}
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name                   = "${var.eks_cluster_name}-${random_string.random.result}"
  cluster_version                = var.eks_cluster_version
  cluster_endpoint_public_access = false  # Access the EKS cluster privately
  cluster_endpoint_private_access = true

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  eks_managed_node_group_defaults = {
    ami_type              = "AL2_x86_64"
    instance_types        = var.instance_type
    vpc_security_group_ids = [aws_security_group.allow_all.id]
  }

  eks_managed_node_groups = {
    node_group = {
      min_size       = var.eks_cluster_minimum_size
      max_size       = var.eks_cluster_maximum_size
      desired_size   = var.eks_cluster_desired_size
      instance_types = var.instance_type
    }
  }

  tags = {
    Name        = var.eks_cluster_name
    Environment = var.env
  }
}