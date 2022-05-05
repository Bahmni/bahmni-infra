variable "vpc_suffix" {
  type        = string
  description = "Suffix Value for VPC related resources (Ex: prod,non-prod)"
}

variable "public_access_cidr_block" {
  type        = string
  description = "CIDR Block used for SSH Access"
}

variable "ami_name" {
  type        = string
  description = "Name of the AMI to be used for nodes"
}
