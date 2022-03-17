
output "VPC-info" {
  value = {
    bucket         = aws_s3_bucket.state_file.bucket
    dynamodb_table = aws_dynamodb_table.terraform_lock.name
  }
}