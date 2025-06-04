output "bastion_id" {
  value = aws_instance.bastion.id
}

output "web_id" {
  value = aws_instance.web.id
}

output "app_id" {
  value = aws_instance.app.id
}
