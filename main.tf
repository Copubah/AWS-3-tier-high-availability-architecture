

# Provider Configuration
provider "aws" {
  region = var.aws_region

  default_tags {
    tags = merge(var.common_tags, {
      Environment = var.environment
      ManagedBy   = "terraform"
    })
  }
}

# Local Values
locals {
  name_prefix = "${var.project_name}-${var.environment}"
}

# Networking Module
module "networking" {
  source = "./modules/networking"

  project_name           = var.project_name
  environment           = var.environment
  vpc_cidr              = var.vpc_cidr
  availability_zones    = var.availability_zones
  public_subnet_cidrs   = var.public_subnet_cidrs
  private_subnet_cidrs  = var.private_subnet_cidrs
  common_tags           = var.common_tags
}

# Security Module
module "security" {
  source = "./modules/security"

  project_name      = var.project_name
  environment       = var.environment
  vpc_id            = module.networking.vpc_id
  vpc_cidr_block    = module.networking.vpc_cidr_block
  allowed_ssh_cidrs = var.allowed_ssh_cidrs
  common_tags       = var.common_tags
}

# Compute Module
module "compute" {
  source = "./modules/compute"

  project_name               = var.project_name
  environment               = var.environment
  instance_type             = var.instance_type
  key_name                  = var.key_name
  public_subnet_ids         = module.networking.public_subnet_ids
  private_subnet_ids        = module.networking.private_subnet_ids
  bastion_security_group_id = module.security.bastion_security_group_id
  web_security_group_id     = module.security.web_security_group_id
  app_security_group_id     = module.security.app_security_group_id
  common_tags               = var.common_tags
}

# Database Module
module "database" {
  source = "./modules/database"

  project_name               = var.project_name
  environment               = var.environment
  private_subnet_ids        = module.networking.private_subnet_ids
  database_security_group_id = module.security.database_security_group_id
  db_instance_class         = var.db_instance_class
  db_allocated_storage      = var.db_allocated_storage
  db_username               = var.db_username
  db_password               = var.db_password
  enable_multi_az           = var.enable_multi_az
  backup_retention_period   = var.backup_retention_period
  common_tags               = var.common_tags
}


