variable "environment" {
  type        = string
  description = "Environment Value used to create and tag resources"
}

variable "owner" {
  type        = string
  description = "Owner name used for tagging resources"
}

variable "tmpdir" {
  default = "../"
}

variable "keyname" {
  default = "key-cluster-node"
}

variable "tags" {
  default = ""
}

variable "region" {
  default = "ap-south-1"
}

variable "aws_key_pair" {
  default = false
}

variable "node_instance_type" {
  default = "m5.xlarge"
}
variable "name_prefix" {
  default = "bahmni"
}

variable "vpc_suffix" {
  type        = string
  description = "Suffix Value for VPC related resources (Ex: prod,non-prod)"
}

variable "cluster_whitelist_ips" {}
