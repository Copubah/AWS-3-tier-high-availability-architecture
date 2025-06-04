provider "aws" {
  region = "us-east-1"
}

module "vpc" {
  source = "../../modules/vpc"
}

module "security_groups" {
  source     = "../../modules/security_groups"
  vpc_id     = module.vpc.vpc_id
  web_ports  = [80, 22]
  app_ports  = [3306]
  bastion_ports = [22]
}

module "ec2_instance" {
  source              = "../../modules/ec2_instance"
  ami_id              = var.ami_id
  instance_type       = "t2.micro"
  key_name            = var.key_name
  public_subnet_id    = module.vpc.public_subnet_id
  private_subnet_ids  = module.vpc.private_subnet_ids
  bastion_sg          = module.security_groups.bastion_sg_id
  web_sg              = module.security_groups.web_sg_id
  app_sg              = module.security_groups.app_sg_id
}

module "rds" {
  source             = "../../modules/rds"
  private_subnet_ids = module.vpc.private_subnet_ids
  db_user            = "root"
  db_password        = "Re:Start!9"
  db_sg              = module.security_groups.db_sg_id
}
