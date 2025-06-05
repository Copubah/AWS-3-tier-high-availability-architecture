variable "vpc_id" {
  description = "VPC ID where security groups will be created"
  type        = string
}

variable "bastion_ports" {
  description = "List of ports for bastion host"
  type        = list(number)
  default     = [22]
}

variable "web_ports" {
  description = "List of ports for web server"
  type        = list(number)
  default     = [80]
}

variable "app_ports" {
  description = "List of ports for app server"
  type        = list(number)
  default     = [3306]
}
