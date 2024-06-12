resource "aws_db_parameter_group" "custom_mysql_parameters" {
  name   = "mysql-custom-parameter-group-${var.environment}"
  family = "mysql8.0"

  lifecycle {
    create_before_destroy = true
  }

  parameter {
    name         = "log_bin_trust_function_creators"
    value        = 1
    apply_method = "immediate"
  }

  parameter {
    name  = "character_set_server"
    value = "utf8"
  }

  parameter {
    name  = "collation_server"
    value = "utf8_general_ci"
  }

  parameter {
    name  = "time_zone"
    value = var.mysql_time_zone
  }
}
