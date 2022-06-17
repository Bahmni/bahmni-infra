variable "availability_zones" {
  type        = list(string)
  description = "Availability Zone for creating the resource"
}

variable "environment" {
  type        = string
  description = "Name of the environment with which resource names would be suffixed"
}

variable "owner" {
  type        = string
  description = "Owner name for resource tags"
}

variable "private_cidr_blocks" {
  type        = list(string)
  description = "CIDR Blocks used for private subnets"
}

variable "public_cidr_blocks" {
  type        = list(string)
  description = "CIDR Blocks used for public subnets"
}

variable "vpc_cidr_block" {
  type        = string
  description = "CIDR Block used for VPC"
}



variable "desired_num_of_nodes" {
  type        = number
  description = "Number of desired nodes in the default node group"
}

variable "min_num_of_nodes" {
  type        = number
  description = "Number of minimum nodes in the default node group"
}

variable "max_num_of_nodes" {
  type        = number
  description = "Number of maximum nodes in the default node group"
}

variable "ami_name" {
  type        = string
  description = "Name of the AMI to be used for nodes"
}

variable "node_instance_type" {
  type        = string
  description = "Type of Instance to be used for nodes"
}

variable "vpc_suffix" {
  type        = string
  description = "Suffix Value for VPC related resources (Ex: prod,non-prod)"
}

variable "mysql_version" {
  type        = string
  description = "MySQL Version for RDS instance"
}

variable "rds_instance_class" {
  type        = string
  description = "Instance class for RDS Instance"
}

variable "mysql_rds_port" {
  type        = string
  description = "RDS Port for MySQL Instance"
}

#variable "bastion_public_access_cidr" {
#  type        = string
#  description = "CIDR Block used for SSH Access of Bastion Host"
#}
