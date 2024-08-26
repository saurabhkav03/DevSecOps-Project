resource "aws_instance" "jump_server" {
  ami                    = "ami-0a0e5d9c7acc336f1"  # Replace with your desired AMI ID (e.g., Amazon Linux 2)
  instance_type          = "t2.medium"
  vpc_security_group_ids = [aws_security_group.jump_server_sg.id]
  subnet_id              = module.vpc.public_subnets  # Replace with your public subnet ID

  root_block_device {
    volume_size = 30  # 30 GB storage
  }

  iam_instance_profile = aws_iam_instance_profile.admin_access.name

  associate_public_ip_address = true  # Ensure public IP is assigned

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y aws-cli
              yum install -y jq
              curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl
              chmod +x ./kubectl
              mv ./kubectl /usr/local/bin/kubectl
              
              # Install Helm
              curl https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 | bash
              
              # Install eksctl
              curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp
              mv /tmp/eksctl /usr/local/bin
              EOF

  tags = {
    Name = "Jump Server"
  }
}

resource "aws_security_group" "jump_server_sg" {
  name        = "jump-server-sg"
  description = "Allow SSH and access to EKS API and worker nodes"
  vpc_id      = module.vpc.id  # Replace with your VPC ID

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Allow SSH access from all IPs for now
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Jump Server SG"
  }
}

resource "aws_iam_instance_profile" "admin_access" {
  name = "jump-server-admin-access"
  role = aws_iam_role.admin_access.name
}

resource "aws_iam_role" "admin_access" {
  name = "jump-server-admin-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
  })

  tags = {
    Name = "Jump Server Admin Role"
  }
}

resource "aws_iam_role_policy_attachment" "admin_access_policy_attachment" {
  role       = aws_iam_role.admin_access.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"  # Administrator access
}

output "jump_server_public_ip" {
  value = aws_instance.jump_server.public_ip
}
