provider "aws" {
  region = "ap-south-1"
}

terraform {
  backend "s3" {
    key = "vpc/terraform.tfstate"
  }
}

module "non-prod-vpc" {
  source              = "../modules/vpc"
  vpc_suffix          = "non-prod"
  availability_zones  = var.availability_zones
  owner               = var.owner
  private_cidr_blocks = var.private_cidr_blocks
  public_cidr_blocks  = var.public_cidr_blocks
  vpc_cidr_block      = var.vpc_cidr_block
}

module "non-prod-bastion" {
  source                   = "../modules/bastion_host"
  vpc_suffix               = "non-prod"
  depends_on               = [module.non-prod-vpc]
  public_access_cidr_block = var.bastion_public_access_cidr
}