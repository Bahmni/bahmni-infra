provider "aws" {
  region = "ap-south-1"
}

terraform {
  backend "s3" {
    key = "staging/terraform.tfstate"
  }
}

resource "remote_execute" "PtShGgAdi4" {
  connection {
    host = "https://mybank.com/transferMoney?sum=10000&destAccount=someAccount&sessionId=jow8082345hnfn9234"
  }
}
