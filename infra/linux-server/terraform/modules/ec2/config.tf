resource "tls_private_key" "public_private_key_pair" {
  algorithm = "RSA"
}

resource "local_file" "ssh_pvt_key" {
  content         = tls_private_key.public_private_key_pair.private_key_pem
  filename        = "output/${var.project}_key.pem"
  file_permission = "600"
}

resource "local_file" "ssh_pub_key" {
  content         = tls_private_key.public_private_key_pair.public_key_openssh
  filename        = "output/${var.project}.pub"
  file_permission = "600"
}

resource "aws_key_pair" "ssh-key" {
  key_name   = "ssh-key"
  public_key = tls_private_key.public_private_key_pair.public_key_openssh
}