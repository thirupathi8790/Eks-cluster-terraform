output "eks_cluster_name" {
  description = "The name of the EKS cluster."
  value       = aws_eks_cluster.Eks.name
}

output "eks_cluster_endpoint" {
  description = "The endpoint for the EKS cluster."
  value       = aws_eks_cluster.Eks.endpoint
}

output "eks_cluster_arn" {
  description = "The ARN of the EKS cluster."
  value       = aws_eks_cluster.Eks.arn
}
