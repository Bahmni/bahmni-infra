environment                     = "nonprod"
vpc_suffix                      = "nonprod"
owner                           = "bahmni-infra"
availability_zones              = ["ap-south-1a", "ap-south-1b"]
private_cidr_blocks             = ["10.0.1.0/24", "10.0.2.0/24"]
public_cidr_blocks              = ["10.0.3.0/24", "10.0.4.0/24"]
vpc_cidr_block                  = "10.0.0.0/16"
rds_instance_class              = "db.t3.large"
rds_allow_major_version_upgrade = true
mysql_version                   = "8.0"
mysql_rds_port                  = "3306"
mysql_time_zone                 = "Asia/Calcutta"
enable_bastion_host             = false
bastion_public_access_cidr      = "0.0.0.0/0"
enable_ses                      = true
eks_version                     = "1.26"
