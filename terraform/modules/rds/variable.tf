variable "environment" {
  type        = string
  description = "Environment Value used to create and tag resources"
}

variable "mysql_rds_port" {
  type        = string
  description = "RDS Port for MySQL Instance"
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