resource "aws_instance" "bastion" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = var.public_subnet_id
  vpc_security_group_ids      = [var.bastion_sg]
  key_name                    = var.key_name
  associate_public_ip_address = true

  tags = {
    Name = "BastionHost"
  }
}

resource "aws_instance" "web" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = var.private_subnet_ids[0]
  vpc_security_group_ids = [var.web_sg]
  key_name               = var.key_name
  user_data              = file("${path.module}/web_userdata.sh")

  tags = {
    Name = "WebServer"
  }
}

resource "aws_instance" "app" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = var.private_subnet_ids[1]
  vpc_security_group_ids = [var.app_sg]
  key_name               = var.key_name
  user_data              = file("${path.module}/app_userdata.sh")

  tags = {
    Name = "AppServer"
  }
}
