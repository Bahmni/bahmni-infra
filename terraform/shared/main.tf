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
    key = "vpc/terraform.tfstate"
  }
}

module "non_prod_vpc" {
  source              = "../modules/vpc"
  vpc_suffix          = "non-prod"
  availability_zones  = var.availability_zones
  owner               = var.owner
  private_cidr_blocks = var.private_cidr_blocks
  public_cidr_blocks  = var.public_cidr_blocks
  vpc_cidr_block      = var.vpc_cidr_block
}

module "non_prod_bastion" {
  source                   = "../modules/bastion_host"
  vpc_suffix               = "non-prod"
  depends_on               = [module.non_prod_vpc]
  public_access_cidr_block = var.bastion_public_access_cidr
  ami_name                 = var.ami_name
}
