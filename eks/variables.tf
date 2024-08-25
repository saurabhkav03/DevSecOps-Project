variable "aws_region" {
  description = "The AWS region to deploy resources in"
  type        = string
  default     = "us-east-1"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "private_subnets" {
  description = "Private subnets for the VPC"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "public_subnets" {
  description = "Public subnets for the VPC"
  type        = list(string)
  default     = ["10.0.101.0/24", "10.0.102.0/24"]
}

variable "enable_nat_gateway" {
  description = "Enable NAT Gateway (true/false)"
  type        = bool
  default     = true
}

variable "single_nat_gateway" {
  description = "Enable Single NAT Gateway (true/false)"
  type        = bool
  default     = false
}

variable "name" {
  description = "Name for the resources"
  type        = string
  default     = "mern-stack"
}

variable "env" {
  description = "Environment for the deployment (e.g., dev, prod)"
  type        = string
  default     = "dev"
}

variable "eks_cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
  default     = "mern-stack"
}

variable "eks_cluster_version" {
  description = "Kubernetes version for the EKS cluster"
  type        = string
  default     = "1.30"
}

variable "instance_type" {
  description = "EC2 instance type for EKS worker nodes"
  type        = list(string)
  default     = ["t2.micro"]
}

variable "eks_cluster_minimum_size" {
  description = "Minimum number of worker nodes in the EKS cluster"
  type        = number
  default     = 1
}

variable "eks_cluster_maximum_size" {
  description = "Maximum number of worker nodes in the EKS cluster"
  type        = number
  default     = 4
}

variable "eks_cluster_desired_size" {
  description = "Desired number of worker nodes in the EKS cluster"
  type        = number
  default     = 2
}

variable "sg_name" {
  description = "Name of the security group"
  type        = string
  default     = "allow_all"
}

variable "description" {
  description = "Description of the security group"
  type        = string
  default     = "Allow all inbound traffic and all outbound traffic"
}

variable "ingress_cidr_ipv4" {
  description = "IPv4 CIDR blocks for ingress traffic"
  type        = string
  default     = "10.0.0.0/8"
}

variable "egress_cidr_ipv4" {
  description = "IPv4 CIDR block for egress traffic"
  type        = string
  default     = "0.0.0.0/0"
}
