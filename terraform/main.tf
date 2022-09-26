provider "aws" {
  region = "ap-south-1"
}

terraform {
  required_version = "~>1.3.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.9.0"
    }
  }

  backend "s3" {
  }
}


module "vpc" {
  source              = "./modules/vpc"
  vpc_suffix          = var.vpc_suffix
  availability_zones  = var.availability_zones
  owner               = var.owner
  private_cidr_blocks = var.private_cidr_blocks
  public_cidr_blocks  = var.public_cidr_blocks
  vpc_cidr_block      = var.vpc_cidr_block
}

module "efs" {
  source              = "./modules/efs"
  depends_on          = [module.vpc]
  environment         = var.environment
  vpc_suffix          = var.vpc_suffix
  private_cidr_blocks = var.private_cidr_blocks
}

module "eks" {
  source              = "./modules/eks"
  depends_on          = [module.vpc]
  environment         = var.environment
  owner               = var.owner
  vpc_suffix          = var.vpc_suffix
  efs_file_system_arn = module.efs.efs-file-system-arn
}

module "rds" {
  source             = "./modules/rds"
  depends_on         = [module.vpc]
  environment        = var.environment
  vpc_suffix         = var.vpc_suffix
  mysql_rds_port     = var.mysql_rds_port
  mysql_version      = var.mysql_version
  rds_instance_class = var.rds_instance_class
}

module "bastion" {
  source                   = "./modules/bastion_host"
  count                    = var.enable_bastion_host ? 1 : 0
  depends_on               = [module.vpc]
  vpc_suffix               = var.vpc_suffix
  public_access_cidr_block = var.bastion_public_access_cidr
}
