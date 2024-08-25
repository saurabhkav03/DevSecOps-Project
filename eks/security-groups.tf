resource "aws_security_group" "allow_all" {
  name        = var.sg_name
  description = var.description
  vpc_id      = module.vpc.vpc_id

  tags = {
    Name = var.sg_name
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_all_ipv4" {
  security_group_id = aws_security_group.allow_all.id
  cidr_ipv4       = var.ingress_cidr_ipv4
  from_port         = 0
  ip_protocol       = "-1"
  to_port           = 0
}


resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.allow_all.id
  cidr_ipv4         = var.egress_cidr_ipv4
  ip_protocol       = "-1"
}
