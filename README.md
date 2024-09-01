# DevSecOps MERN Stack Application Deployment

This repository contains Terraform scripts and Jenkins pipelines to deploy a MERN stack application in an EKS cluster within a private VPC. Below are the detailed steps to set up and deploy the infrastructure.

## Prerequisites

- **AWS Account**: Ensure you have an AWS account with sufficient permissions to create EC2 instances, VPCs, and EKS clusters.
- **Jenkins Server**: The Terraform files and Jenkins pipelines will be executed from a Jenkins server.

## Jenkins Server Setup

1. **Launch EC2 Instance**:
   - **Operating System**: Ubuntu
   - **Instance Type**: t2.2xlarge
   - **VPC**: Default VPC
   - **Security Group**: Use an existing security group or create a new one.
   - **Storage**: 30 GB
   - **IAM Role**: Attach an IAM instance profile with administrative access.
   - **User Data**: Use the following script to install the necessary tools:
     - JDK
     - Jenkins
     - Docker
     - Terraform
     - AWS CLI
     - SonarQube (via Docker container)
     - Trivy

     You can use our [installation script](https://github.com/saurabhkav03/DevSecOps-Project/blob/main/tools-install.sh).

2. **Disable SSH Access**: To enhance security, disable SSH access to the instance.

## Infrastructure Deployment

### Step 1: Create the Infrastructure

1. **Login to Jenkins Server**.
2. **Install Required Jenkins Plugins**:
   - AWS Credentials
   - AWS Pipeline
   - Terraform

3. **Configure Jenkins Credentials**:
   - Store AWS credentials with ID `aws-creds`.
   - Add other necessary credentials like SonarQube tokens and GitHub PATs.

4. **Configure Terraform in Jenkins**:
   - Provide the path to the Terraform executable. Find the directory using the command `whereis terraform`.

5. **Create Terraform Files for EKS**:
   - Create and commit the necessary Terraform files for setting up the EKS cluster.

6. **Create a Jenkins Pipeline**:
   - Create a Jenkins pipeline to deploy the EKS cluster using the Terraform files.

7. **Run Terraform Apply**:
   - Use the pipeline to apply the Terraform configuration and create the infrastructure.

### Step 2: Create a Jump Server

1. **Launch EC2 Instance**:
   - **Instance Type**: t2.medium
   - **VPC**: Newly created VPC
   - **Subnet**: Public subnet
   - **Storage**: 30 GB
   - **IAM Role**: Provide administrative access.
   - **User Data**: Install AWS CLI, kubectl, Helm, and eksctl.

2. **Configure the Jump Server**:
   - Use the following command to configure kubectl to interact with the EKS cluster:
     ```sh
     aws eks update-kubeconfig --name dev-meduim-cluster --region us-east-1
     ```
   - Verify the setup with:
     ```sh
     kubectl get nodes
     ```

### Step 3: Install AWS ALB and ArgoCD

1. **Install AWS ALB Ingress Controller**:
   - Download and create the required IAM policy.
   - Create a service account using `eksctl`.
   - Deploy the ALB Ingress controller and verify its deployment:
     ```sh
     kubectl get deployment -n kube-system
     ```

2. **Configure ArgoCD**:
   - Deploy ArgoCD and expose it via a LoadBalancer.
   - Verify the setup with:
     ```sh
     kubectl get all -n argocd
     ```

### Step 4: SonarQube Integration

1. **Login to SonarQube**:
   - Generate a token in SonarQube for Jenkins integration.
   - Create webhooks in SonarQube to notify Jenkins of code quality results.

2. **Create Projects**:
   - Create separate projects for the frontend and backend in SonarQube.

### Step 5: Configure Jenkins for CI/CD

1. **Add Private ECR Repositories**:
   - Create ECR repositories in AWS for storing frontend and backend Docker images.

2. **Install Jenkins Plugins**:
   - Install Docker, Node.js, OWASP Dependency Check, and SonarQube plugins.

3. **Configure Jenkins Tools and Secrets**:
   - Add secret text values for SonarQube tokens, AWS account ID, ECR repository credentials, GitHub credentials, and PAT.

4. **Create Jenkins Pipelines**:
   - Set up Jenkins pipelines for frontend and backend applications. The pipeline should include:
     - Code quality analysis
     - Dependency checks
     - Trivy file and image scans
     - Docker image build and push to ECR
     - Deployment file updates

### Step 6: ArgoCD Configuration

1. **Set Up ArgoCD Applications**:
   - Configure ArgoCD to deploy the database, backend, and frontend services.
   - Use GitHub repositories to deploy database manifests in the EKS cluster.

### Step 7: DNS Configuration

1. **Route53 Setup**:
   - Map your domain to the ALB DNS.
   - Add A record and set the alias to the ALB endpoint.

### Step 8: Monitoring Setup

1. **Install Prometheus and Grafana**:
   - Deploy Prometheus and Grafana on the Jump Server.
   - Set the service type as `LoadBalancer`.
   - Configure Prometheus as a data source for Grafana.

2. **Access Monitoring Dashboards**:
   - Import Grafana dashboards using ID 6417 or 17375.

## Conclusion

All the resources and infrastructure should now be set up and running. You can monitor your application via Grafana and ensure everything is functioning correctly.
