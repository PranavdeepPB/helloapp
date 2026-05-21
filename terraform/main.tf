module "vpc" {
  source       = "./modules/vpc"
  project_name = var.project_name
}

module "ecr" {
  source       = "./modules/ecr"
  project_name = var.project_name
}

module "eks" {
  source                 = "./modules/eks"
  project_name           = var.project_name
  vpc_id                 = module.vpc.vpc_id
  subnet_ids             = module.vpc.public_subnet_ids
  eks_node_instance_type = var.eks_node_instance_type
  eks_desired_nodes      = var.eks_desired_nodes
  eks_ami_type           = var.eks_ami_type
}