output "bastion_sg" {
  value = aws_security_group.bastion.id
}

output "web_sg" {
  value = aws_security_group.web.id
}

output "app_sg" {
  value = aws_security_group.app.id
}

output "db_sg" {
  value = aws_security_group.db.id
}
