resource "aws_db_subnet_group" "db_subnet_group" {
  name       = "db-subnet-group"
  subnet_ids = var.private_subnet_ids

  tags = {
    Name = "db-subnet-group"
  }
}

resource "aws_db_instance" "db" {
  allocated_storage         = 20
  engine                    = "mariadb"
  engine_version            = "10.6"
  instance_class            = "db.t3.micro"
  name                      = "mydb"
  username                  = var.db_user
  password                  = var.db_password
  db_subnet_group_name      = aws_db_subnet_group.db_subnet_group.name
  vpc_security_group_ids    = [var.db_sg]
  skip_final_snapshot       = true
  backup_retention_period   = 0
  publicly_accessible       = false
}
