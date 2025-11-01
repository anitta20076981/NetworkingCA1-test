terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

############################################
# DATA SOURCES
############################################

# Use existing VPC
data "aws_vpc" "selected" {
  id = "vpc-09192546bb7779694"
}

# Use existing subnets in that VPC
data "aws_subnets" "existing" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.selected.id]
  }
}

# Existing ECR repository
data "aws_ecr_repository" "app" {
  name = var.ecr_name
}

############################################
# IAM ROLE FOR EKS
############################################

# EKS assume role policy
data "aws_iam_policy_document" "eks_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["eks.amazonaws.com"]
    }
  }
}

# Random suffix to avoid duplicate names
resource "random_id" "suffix" {
  byte_length = 2
}

# IAM role for EKS cluster
resource "aws_iam_role" "eks_cluster_role" {
  name               = "${var.eks_role_name}-${random_id.suffix.hex}"
  assume_role_policy = data.aws_iam_policy_document.eks_assume_role.json
}

# Attach EKS managed policies
resource "aws_iam_role_policy_attachment" "cluster_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks_cluster_role.name
}

resource "aws_iam_role_policy_attachment" "vpc_cni_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.eks_cluster_role.name
}

############################################
# EKS CLUSTER
############################################

resource "aws_eks_cluster" "eks" {
  name     = "${var.eks_cluster_name}-${random_id.suffix.hex}"
  role_arn = aws_iam_role.eks_cluster_role.arn

  vpc_config {
    subnet_ids             = data.aws_subnets.existing.ids
    endpoint_public_access = true
  }

  depends_on = [
    aws_iam_role_policy_attachment.cluster_policy,
    aws_iam_role_policy_attachment.vpc_cni_policy
  ]

  tags = {
    Name        = "EKS-Cluster"
    Environment = "Development"
  }
}
