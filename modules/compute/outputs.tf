output "bastion_instance_id" {
  description = "ID of the bastion instance"
  value       = aws_instance.bastion.id
}

output "bastion_public_ip" {
  description = "Public IP of the bastion instance"
  value       = aws_instance.bastion.public_ip
}

output "web_instance_id" {
  description = "ID of the web instance"
  value       = aws_instance.web.id
}

output "web_public_ip" {
  description = "Public IP of the web instance"
  value       = aws_instance.web.public_ip
}

output "web_private_ip" {
  description = "Private IP of the web instance"
  value       = aws_instance.web.private_ip
}

output "app_instance_id" {
  description = "ID of the app instance"
  value       = aws_instance.app.id
}

output "app_private_ip" {
  description = "Private IP of the app instance"
  value       = aws_instance.app.private_ip
}