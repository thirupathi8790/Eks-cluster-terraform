provider "aws" {
  region = "us-east-1"  # Change this to your desired region
}

resource "aws_eks_cluster" "Eks" {
  name     = "Eks-cluster"
  role_arn  = aws_iam_role.eks.arn

  vpc_config {
    subnet_ids = aws_subnet.eks[*].id
  }

  # Specify EKS version
  version = "1.24"  # Change to the version you need
}

resource "aws_iam_role" "eks" {
  name = "Demo-eks-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "eks.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "eks" {
  role       = aws_iam_role.eks.name
  policy_arn  = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

resource "aws_vpc" "Eks" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "Eks-vpc"
  }
}

resource "aws_subnet" "Eks" {
  count                   = 2
  cidr_block              = cidrsubnet(aws_vpc.Eks.cidr_block, 8, count.index)
  vpc_id                  = aws_vpc.Eks.id
  availability_zone       = element(data.aws_availability_zones.available.names, count.index)

  tags = {
    Name = "Eks-subnet-${count.index}"
  }
}

data "aws_availability_zones" "available" {}

output "cluster_name" {
  value = aws_eks_cluster.Eks.name
}

output "cluster_endpoint" {
  value = aws_eks_cluster.Eks.endpoint
}

output "cluster_arn" {
  value = aws_eks_cluster.Eks.arn
}
