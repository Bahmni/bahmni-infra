provider "aws" {
  region = "ap-south-1"
}

terraform {
  backend "s3" {
    key = "staging/terraform.tfstate"
  }
}

