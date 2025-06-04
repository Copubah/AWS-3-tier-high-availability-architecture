variable "ami_id" {}
variable "instance_type" {}
variable "key_name" {}
variable "public_subnet_id" {}
variable "private_subnet_ids" {
  type = list(string)
}
variable "bastion_sg" {}
variable "web_sg" {}
variable "app_sg" {}
