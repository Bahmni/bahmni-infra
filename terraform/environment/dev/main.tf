provider "aws" {
  region = "ap-south-1"
}

terraform {
  backend "s3" {
    bucket         = "bahmni-tf-bucket"
    key            = "dev/terraform.tfstate"
    region         = "ap-south-1"
    dynamodb_table = "bahmni-tf-lock"
  }
}

locals {
  environment = "dev"
}

module "dev-eks" {
  source                = "../../modules/eks"
  environment           = local.environment
  owner                 = var.owner
  cluster_whitelist_ips = ""
  vpc_suffix            = "non-prod"
}
