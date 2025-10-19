# Local Values
locals {
  name_prefix = "${var.project_name}-${var.environment}"
  
  common_tags = merge(var.common_tags, {
    Environment = var.environment
    Project     = var.project_name
  })
}

# Data Sources
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# Launch Template for Web Servers
resource "aws_launch_template" "web" {
  name_prefix   = "${local.name_prefix}-web-"
  description   = "Launch template for web servers"
  image_id      = data.aws_ami.amazon_linux.id
  instance_type = var.instance_type
  key_name      = var.key_name

  vpc_security_group_ids = [var.web_security_group_id]

  user_data = base64encode(templatefile("${path.module}/user_data/web_server.sh", {}))

  tag_specifications {
    resource_type = "instance"
    tags = merge(local.common_tags, {
      Name = "${local.name_prefix}-web-server"
      Tier = "Web"
    })
  }

  lifecycle {
    create_before_destroy = true
  }
}

# Bastion Host
resource "aws_instance" "bastion" {
  ami                         = data.aws_ami.amazon_linux.id
  instance_type               = var.instance_type
  subnet_id                   = var.public_subnet_ids[0]
  key_name                    = var.key_name
  vpc_security_group_ids      = [var.bastion_security_group_id]
  associate_public_ip_address = true

  user_data = base64encode(templatefile("${path.module}/user_data/bastion.sh", {}))

  tags = merge(local.common_tags, {
    Name = "${local.name_prefix}-bastion"
    Tier = "Public"
  })
}

# Web Server
resource "aws_instance" "web" {
  ami                         = data.aws_ami.amazon_linux.id
  instance_type               = var.instance_type
  subnet_id                   = var.public_subnet_ids[0]
  key_name                    = var.key_name
  vpc_security_group_ids      = [var.web_security_group_id]
  associate_public_ip_address = true

  user_data = base64encode(templatefile("${path.module}/user_data/web_server.sh", {}))

  tags = merge(local.common_tags, {
    Name = "${local.name_prefix}-web-server"
    Tier = "Web"
  })
}

# Application Server
resource "aws_instance" "app" {
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = var.instance_type
  subnet_id              = var.private_subnet_ids[0]
  key_name               = var.key_name
  vpc_security_group_ids = [var.app_security_group_id]

  user_data = base64encode(templatefile("${path.module}/user_data/app_server.sh", {}))

  tags = merge(local.common_tags, {
    Name = "${local.name_prefix}-app-server"
    Tier = "Application"
  })
}