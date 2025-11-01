############################################
# AWS Configuration
############################################

variable "aws_region" {
  description = "AWS region for deployment"
  type        = string
  default     = "eu-north-1"
}

############################################
# Networking Configuration
############################################

variable "vpc_id" {
  description = "Use an existing VPC ID (leave empty to create a new one)"
  type        = string
  default     = "" # Set to "vpc-xxxx" if reusing an existing VPC
}

############################################
# EKS Cluster Configuration
############################################

variable "eks_cluster_name" {
  description = "Base name for the EKS cluster (random suffix added automatically)"
  type        = string
  default     = "terraform-eks-cluster"
}

variable "eks_role_name" {
  description = "Base IAM role name for EKS cluster (random suffix avoids conflicts)"
  type        = string
  default     = "terraform-eks-cluster-role"
}

############################################
# ECR Repository Configuration
############################################

variable "ecr_name" {
  description = "Existing ECR repository name (Terraform will reuse it)"
  type        = string
  default     = "my-simple-app1"
}
