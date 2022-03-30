variable "owner" {
  type        = string
  description = "Owner name used for tagging resources"
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
