resource "aws_db_subnet_group" "main" {
  name       = var.db_subnet_group_name
  subnet_ids = [var.subnet_id]

  tags = {
    Name = "main-db-subnet-group"
  }
}

resource "aws_db_instance" "main" {
  identifier           = var.instance_identifier
  engine              = "mysql"
  engine_version      = var.aws_db_instance_engine_version
  instance_class      = var.instance_class
  allocated_storage   = var.instance_storage
  storage_type        = var.instance_storage_type
  
  db_name             = var.db_name
  username            = var.db_username
  password            = var.db_password
  
  db_subnet_group_name   = aws_db_subnet_group.main.name
  vpc_security_group_ids = [var.security_group_id]
  
  skip_final_snapshot    = true
  
  tags = {
    Name = "main-db-instance"
  }
}