output "eks_cluster_name" {
  description = "EKS cluster name (with random suffix)"
  value       = aws_eks_cluster.eks.name
}

output "ecr_repository_uri" {
  description = "URI of the existing ECR repository"
  value       = data.aws_ecr_repository.app.repository_url
}

output "iam_role_name" {
  description = "Name of the IAM role used for the EKS cluster"
  value       = aws_iam_role.eks_cluster_role.name
}
