resource "aws_launch_configuration" "node" {
  depends_on = [aws_key_pair.dbca_temp_key]
  associate_public_ip_address = true
  iam_instance_profile        = aws_iam_instance_profile
  image_id                    = data.aws_ami.aws-linux.id
  key_name                    = var.keyname
  instance_type               = var.node_instance_type
  name_prefix                 = "bahmni-cluster"
  security_groups             = aws_security_group.node
//  user_data_base64            = base64encode(local.node-userdata)

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "node" {
launch_configuration = aws_launch_configuration.node.id
desired_capacity     = 1
max_size             = 2
min_size             = 1
name                 = "${aws_launch_configuration.node.name}-asg"
vpc_zone_identifier  = [data.aws_subnet_ids.private_subnet_ids.ids]

tag {
key                 = "Name"
value               = "${var.name_prefix}-bahmni-cluster"
propagate_at_launch = true
}
  tag {
    key                 = "kubernetes.io/cluster/bahmni-cluster"
    value               = "owned"
    propagate_at_launch = true
  }
}