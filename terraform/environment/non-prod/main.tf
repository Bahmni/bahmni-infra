provider "aws" {
  region = "ap-south-1"
}

terraform {
  required_version = "~>1.2.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.9.0"
    }
  }

  backend "s3" {
    key = "non-prod/terraform.tfstate"
  }
}


module "non_prod_vpc" {
  source              = "../../modules/vpc"
  vpc_suffix          = var.environment
  availability_zones  = var.availability_zones
  owner               = var.owner
  private_cidr_blocks = var.private_cidr_blocks
  public_cidr_blocks  = var.public_cidr_blocks
  vpc_cidr_block      = var.vpc_cidr_block
}

module "non_prod_eks" {
  source               = "../../modules/eks"
  depends_on           = [module.non_prod_vpc]
  environment          = var.environment
  owner                = var.owner
  vpc_suffix           = var.vpc_suffix
  ami_name             = var.ami_name
  desired_num_of_nodes = var.desired_num_of_nodes
  max_num_of_nodes     = var.max_num_of_nodes
  min_num_of_nodes     = var.min_num_of_nodes
  node_instance_type   = var.node_instance_type
}

module "non_prod_rds" {
  source             = "../../modules/rds"
  depends_on         = [module.non_prod_vpc]
  environment        = var.environment
  vpc_suffix         = var.vpc_suffix
  mysql_rds_port     = var.mysql_rds_port
  mysql_version      = var.mysql_version
  rds_instance_class = var.rds_instance_class
}

#module "non_prod_bastion" {
#  source                   = "../../modules/bastion_host"
#  depends_on               = [module.non_prod_vpc]
#  vpc_suffix               = var.environment
#  public_access_cidr_block = var.bastion_public_access_cidr
#}