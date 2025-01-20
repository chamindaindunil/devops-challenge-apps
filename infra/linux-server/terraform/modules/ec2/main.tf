resource "aws_instance" "ec2" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = var.subnet_id
  associate_public_ip_address = true
  key_name                    = aws_key_pair.ssh-key.key_name
  vpc_security_group_ids = [
    aws_security_group.allow_tls.id
  ]

  root_block_device {
    delete_on_termination = true
    volume_size           = var.disk_size
    volume_type           = "gp3"
  }

  lifecycle {
    ignore_changes = [tags]
  }

  depends_on = [aws_security_group.allow_tls, aws_key_pair.ssh-key]
}

resource "aws_eip" "public_ip" {
  instance = aws_instance.ec2.id
  domain   = "vpc"

  depends_on = [aws_instance.ec2]
}

resource "aws_security_group" "allow_tls" {
  name        = "Allow-TLS"
  description = "Allow ports for public ec2 instance"
  vpc_id      = var.vpc_id
}

resource "aws_vpc_security_group_ingress_rule" "ingress_https" {
  security_group_id = aws_security_group.allow_tls.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 443
  to_port           = 443
  ip_protocol       = "tcp"

  depends_on = [aws_security_group.allow_tls]
}

resource "aws_vpc_security_group_ingress_rule" "ingress_http_ipv4" {
  security_group_id = aws_security_group.allow_tls.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  to_port           = 80
  ip_protocol       = "tcp"

  depends_on = [aws_security_group.allow_tls]
}

resource "aws_vpc_security_group_ingress_rule" "ingress_http_ipv6" {
  security_group_id = aws_security_group.allow_tls.id
  cidr_ipv6         = "::/0"
  from_port         = 80
  to_port           = 80
  ip_protocol       = "tcp"

  depends_on = [aws_security_group.allow_tls]
}

resource "aws_vpc_security_group_ingress_rule" "ingress_ssh" {
  security_group_id = aws_security_group.allow_tls.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  to_port           = 22
  ip_protocol       = "tcp"

  depends_on = [aws_security_group.allow_tls]
}

resource "aws_vpc_security_group_egress_rule" "allow_ipv4" {
  security_group_id = aws_security_group.allow_tls.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"

  depends_on = [aws_security_group.allow_tls]
}

resource "aws_vpc_security_group_egress_rule" "allow_ipv6" {
  security_group_id = aws_security_group.allow_tls.id
  cidr_ipv6         = "::/0"
  ip_protocol       = "-1"

  depends_on = [aws_security_group.allow_tls]
}