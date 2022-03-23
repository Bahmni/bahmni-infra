variable "availability_zone" {
  type        = string
  description = "Availability Zone for creating the resource"
}

variable "owner" {
  type        = string
  description = "Owner name for resource tags"
}

variable "vpc_suffix" {
  type        = string
  description = "Suffix Value for VPC related resources (Ex: prod,non-prod)"
}