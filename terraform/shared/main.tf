provider "aws" {
  region = "ap-south-1"
}

terraform {
  backend "s3" {
    key = "vpc/terraform.tfstate"
  }
}

# Grant bucket access: public
resource "aws_s3_bucket_public_access_block" "publicaccess" {
  bucket = aws_s3_bucket.demobucket.id
  block_public_acls = false
  block_public_policy = false
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
