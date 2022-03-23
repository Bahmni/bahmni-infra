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
  source            = "../modules/vpc"
  availability_zone = "ap-south-1a"
  owner             = "bahmni-infra"
  vpc_suffix        = "non-prod"
}
