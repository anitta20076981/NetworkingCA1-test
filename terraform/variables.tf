variable "aws_region" {
  description = "AWS Region"
  default     = "eu-north-1"
}

variable "eks_cluster_name" {
  description = "EKS cluster name"
  default     = "terraform-eks-cluster"
}

variable "eks_role_name" {
  description = "EKS IAM role name"
  default     = "terraform-eks-cluster-role"
}

variable "ecr_name" {
  description = "ECR repository name"
  default     = "simple-js-app"
}
