variable "project_name" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "subnet_ids" {
  type = list(string)
}

variable "eks_node_instance_type" {
  type    = string
  default = "t3.small"
}

variable "eks_desired_nodes" {
  type    = number
  default = 2
}

variable "eks_ami_type" {
  type    = string
  default = "AL2_x86_64"
}