provider "aws" {
  region = "ap-south-1"
}

terraform {
  backend "s3" {
    bucket         = "bahmni-tf-bucket"
    key            = "vpc/terraform.tfstate"
    region         = "ap-south-1"
    dynamodb_table = "bahmni-tf-lock"
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
