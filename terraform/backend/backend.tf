provider "aws" {
  region = "ap-south-1"
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
  hash_key       = "LockID"
  name           = "bahmni-tf-lock"
  write_capacity = 1
  read_capacity  = 1
  attribute {
    name = "LockID"
    type = "S"
  }
  tags = {
    Name  = "bahmni-tf-lock"
    owner = "bahmni-infra"
  }
}
