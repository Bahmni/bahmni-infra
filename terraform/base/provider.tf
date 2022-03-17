provider "aws" {
  region     = "us-east-1"
}

terraform {
  backend "s3" {
    bucket         = "bahmni-tf-bucket"
    key            = "base/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "bahmni-tf-lock"
  }
}
