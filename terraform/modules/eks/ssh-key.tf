resource "tls_private_key" "master" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "dbca_temp_key" {
  count      = 1
  key_name   = var.keyname
  public_key = tls_private_key.master.public_key_openssh
  tags       = var.tags
}

resource "local_file" "temp_keyfile" {
  content  = tls_private_key.master.private_key_pem
  filename = "${var.tmpdir}/${var.keyname}.pem"
}

resource "null_resource" "chmod_keyfile" {
  depends_on = [local_file.temp_keyfile]
  provisioner "local-exec" {
    command = "chmod 0600 ${var.tmpdir}/${var.keyname}.pem"
  }
}
