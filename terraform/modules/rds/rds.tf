resource "aws_db_subnet_group" "mysql-subnet" {
  name       = "mysql-subnet-group"
  subnet_ids = data.aws_subnets.private_subnets.ids

  tags = {
    Name = "Bahmni MySQL DB Subnet"
  }
}

resource "aws_db_instance" "mysql" {
  identifier             = "bahmni-rds-${var.environment}"
  allocated_storage      = 10
  max_allocated_storage  = 30
  skip_final_snapshot    = true
  engine                 = "mysql"
  engine_version         = var.mysql_version
  instance_class         = var.rds_instance_class
  username               = random_string.mysql_user_name.result
  password               = random_string.mysql_user_password.result
  vpc_security_group_ids = [aws_security_group.rds.id]
  storage_encrypted      = true
  db_subnet_group_name   = aws_db_subnet_group.mysql-subnet.name
  publicly_accessible    = false
  apply_immediately      = true
  port                   = var.mysql_rds_port
}

resource "random_string" "mysql_user_name" {
  length  = 8
  upper   = false
  special = false
}

resource "random_string" "mysql_user_password" {
  length           = 16
  special          = true
  override_special = "@#%&*()-_=+[]{}<>:?"
}
