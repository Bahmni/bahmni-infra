provider "aws" {
  region = "ap-south-1"
}

terraform {
  required_version = "~>1.1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.9.0"
    }
  }

  backend "s3" {
    key = "dev/terraform.tfstate"
  }
}

locals {
  environment = "dev"
}

module "dev_eks" {
  source               = "../../modules/eks"
  environment          = local.environment
  owner                = var.owner
  vpc_suffix           = var.vpc_suffix
  desired_num_of_nodes = var.desired_num_of_nodes
  max_num_of_nodes     = var.max_num_of_nodes
  min_num_of_nodes     = var.min_num_of_nodes
  node_instance_type   = var.node_instance_type
}

module "rds" {
  source             = "../../modules/rds"
  environment        = local.environment
  vpc_suffix         = var.vpc_suffix
  mysql_rds_port     = var.mysql_rds_port
  mysql_version      = var.mysql_version
  rds_instance_class = var.rds_instance_class
}