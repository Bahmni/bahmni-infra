owner                      = "bahmni-infra"
availability_zones         = ["ap-south-1a", "ap-south-1b"]
private_cidr_blocks        = ["10.0.1.0/24", "10.0.2.0/24"]
public_cidr_blocks         = ["10.0.3.0/24", "10.0.4.0/24"]
vpc_cidr_block             = "10.0.0.0/16"
bastion_public_access_cidr = "0.0.0.0/0"
ami_name                   = "amzn2-ami-kernel-5.10-hvm-2.0.20220316.0-x86_64-gp2"
