variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "ap-south-1"
}

variable "project_name" {
  description = "Project name used for resource naming"
  type        = string
  default     = "hello-world"
}

variable "eks_node_instance_type" {
  description = "EC2 instance type for EKS worker nodes"
  type        = string
  default     = "t3.small"
}

variable "eks_desired_nodes" {
  description = "Desired number of worker nodes"
  type        = number
  default     = 2
}

variable "eks_ami_type" {
  type    = string
  default = "AL2_x86_64"
}