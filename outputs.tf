output "bastion_public_ip" {
  value = aws_instance.bastion.public_ip
}

output "web_public_ip" {
  value = aws_instance.web.public_ip
}

output "app_private_ip" {
  value = aws_instance.app.private_ip
}

output "rds_endpoint" {
  value = aws_db_instance.db.endpoint
}
