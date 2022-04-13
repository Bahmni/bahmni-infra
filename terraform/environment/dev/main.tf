provider "aws" {
  region = "ap-south-1"
}

terraform {
  backend "s3" {
    key = "dev/terraform.tfstate"
  }
}

locals {
  environment = "dev"
}

module "dev-eks" {
  #ts:skip=AWS.AEC.LM.MEDIUM.0071 Already applied
  source               = "../../modules/eks"
  environment          = local.environment
  owner                = var.owner
  vpc_suffix           = "non-prod"
  ami_name             = var.ami_name
  desired_num_of_nodes = var.desired_num_of_nodes
  max_num_of_nodes     = var.max_num_of_nodes
  min_num_of_nodes     = var.min_num_of_nodes
  node_instance_type   = var.node_instance_type
}
