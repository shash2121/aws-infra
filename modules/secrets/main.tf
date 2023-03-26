resource "tls_private_key" "pk" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "kp" {
  key_name   = "${terraform.workspace}-key"
  public_key = tls_private_key.pk.public_key_openssh

  # provisioner "local-exec" { 
  #   command = "echo '${tls_private_key.pk.private_key_pem}' > ./keys/${terraform.workspace}.pem"
  # }
}

resource "aws_secretsmanager_secret" "secret" {
  depends_on = [
    aws_key_pair.kp
  ]  
  name = "${terraform.workspace}-key"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "secret_version" {
    depends_on = [
    aws_key_pair.kp
  ]  
  secret_id     = aws_secretsmanager_secret.secret.id
  secret_string = "${tls_private_key.pk.private_key_pem}"
}
