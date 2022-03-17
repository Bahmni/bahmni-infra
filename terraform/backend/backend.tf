provider "aws" {
  region     = "us-east-1"
}

resource "aws_s3_bucket" "state_file" {
  bucket = "bahmni-tf-bucket"

  tags = {
    Name  = "bahmni-statefile"
    owner = "bahmni-infra"
  }
}

resource "aws_s3_bucket_acl" "access" {
  bucket = aws_s3_bucket.state_file.id
  acl    = "private"
}

resource "aws_dynamodb_table" "terraform_lock" {
  hash_key = "lockId"
  name     = "bahmni-tf-lock"
  attribute {
    name = "lockId"
    type = "S"
  }
  tags = {
    name  = "bahmni-tf-lock"
    owner = "bahmni-infra"
  }
}
