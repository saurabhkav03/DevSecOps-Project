
module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  cidr           = var.vpc_cidr
  azs            = data.aws_availability_zones.available.names
  private_subnets = var.private_subnets # Worker nodes should be in private subnets
  public_subnets  = var.public_subnets # NAT Gateways should be in public subnets

  enable_nat_gateway  = var.enable_nat_gateway 
  single_nat_gateway  = var.single_nat_gateway

  enable_dns_hostnames = true 
  enable_dns_support   = true 

  tags = {
    Name = var.name
    Env  = var.env
  }
}
