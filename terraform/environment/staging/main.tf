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
    key = "staging/terraform.tfstate"
  }
}

