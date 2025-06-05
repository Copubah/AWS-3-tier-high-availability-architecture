provider "aws" {
  region = "us-east-1"
}

module "vpc" {
  source = "./modules/vpc"

  vpc_cidr_block = "10.0.0.0/16"
  azs            = ["us-east-1a", "us-east-1b"]

  public_subnet_cidrs = [
    "10.0.1.0/24",
    "10.0.2.0/24"
  ]

  private_subnet_cidrs = [
    "10.0.11.0/24",
    "10.0.12.0/24",
    "10.0.13.0/24"
  ]
}

module "security_groups" {
  source = "./modules/security_groups"

  vpc_id = module.vpc.vpc_id
}

module "ec2_instances" {
  source = "./modules/ec2_instance"

  vpc_id             = module.vpc.vpc_id
  public_subnet_id   = module.vpc.public_subnet_ids[0]
  private_subnet_ids = module.vpc.private_subnet_ids

  bastion_sg_id = module.security_groups.bastion_sg_id
  web_sg_id     = module.security_groups.web_sg_id
  app_sg_id     = module.security_groups.app_sg_id
}

module "rds" {
  source = "./modules/rds"

  db_subnet_ids   = module.vpc.private_subnet_ids
  vpc_id          = module.vpc.vpc_id
  db_sg_id        = module.security_groups.db_sg_id
  db_username     = "root"
  db_password     = "Re:Start!9"
  db_name         = "mydb"
}
