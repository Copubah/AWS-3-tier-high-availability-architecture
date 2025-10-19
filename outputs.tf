# VPC Outputs
output "vpc_id" {
  description = "ID of the VPC"
  value       = module.networking.vpc_id
}

output "vpc_cidr_block" {
  description = "CIDR block of the VPC"
  value       = module.networking.vpc_cidr_block
}

# Subnet Outputs
output "public_subnet_ids" {
  description = "IDs of the public subnets"
  value       = module.networking.public_subnet_ids
}

output "private_subnet_ids" {
  description = "IDs of the private subnets"
  value       = module.networking.private_subnet_ids
}

# Compute Outputs
output "bastion_public_ip" {
  description = "Public IP address of the bastion host"
  value       = module.compute.bastion_public_ip
}

output "bastion_instance_id" {
  description = "Instance ID of the bastion host"
  value       = module.compute.bastion_instance_id
}

output "web_public_ip" {
  description = "Public IP address of the web server"
  value       = module.compute.web_public_ip
}

output "web_private_ip" {
  description = "Private IP address of the web server"
  value       = module.compute.web_private_ip
}

output "web_instance_id" {
  description = "Instance ID of the web server"
  value       = module.compute.web_instance_id
}

output "app_private_ip" {
  description = "Private IP address of the application server"
  value       = module.compute.app_private_ip
}

output "app_instance_id" {
  description = "Instance ID of the application server"
  value       = module.compute.app_instance_id
}

# Database Outputs
output "rds_endpoint" {
  description = "RDS instance endpoint"
  value       = module.database.db_instance_endpoint
}

output "rds_port" {
  description = "RDS instance port"
  value       = module.database.db_instance_port
}

output "database_name" {
  description = "Name of the database"
  value       = module.database.db_instance_name
}

# Connection Information
output "ssh_bastion_command" {
  description = "Command to SSH into the bastion host"
  value       = "ssh -i your-key.pem ec2-user@${module.compute.bastion_public_ip}"
}

output "web_url" {
  description = "URL to access the web application"
  value       = "http://${module.compute.web_public_ip}"
}
