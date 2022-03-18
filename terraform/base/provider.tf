provider "aws" {
  region = var.region
}

terraform {
  backend "s3" {
    bucket         = "bahmni-tf-bucket"
    key            = "base/terraform.tfstate"
    region         = "ap-south-1"
    dynamodb_table = "bahmni-tf-lock"
  }
}
