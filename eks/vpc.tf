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

resource "aws_route_table" "public" {
  vpc_id = module.vpc.vpc_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = module.vpc.internet_gateway_id
  }

  tags = {
    Name = "public-route-table"
  }
}

resource "aws_route_table" "private" {
  vpc_id = module.vpc.vpc_id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = module.vpc.nat_gateway_id
  }

  tags = {
    Name = "private-route-table"
  }
}

# Associate all public subnets with the public route table
resource "aws_route_table_association" "public" {
  count = length(module.vpc.public_subnets)
  subnet_id      = module.vpc.public_subnets[count.index]
  route_table_id = aws_route_table.public.id
}

# Associate all private subnets with the private route table
resource "aws_route_table_association" "private" {
  count = length(module.vpc.private_subnets)
  subnet_id      = module.vpc.private_subnets[count.index]
  route_table_id = aws_route_table.private.id
}
