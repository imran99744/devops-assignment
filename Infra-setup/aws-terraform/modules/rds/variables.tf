variable "subnet_id" {
  description = "Subnet ID where the RDS instance will be launched"
  type        = string
}

variable "security_group_id" {
  description = "Security group ID for the RDS instance"
  type        = string
}

variable "instance_class" {
  description = "RDS instance class"
  type        = string
}

variable "instance_storage" {
  description = "RDS instance storage"
  type        = string
  default = "20"
}

variable "instance_storage_type" {
  description = "RDS instance storage type"
  type        = string
  default = "gp2"
}

variable "instance_identifier" {
  description = "RDS instance identifier"
  type        = string
  default = "main-db-instance"
}

variable "db_name" {
  description = "Name of the database"
  type        = string
  default = "main-db"
}

variable "db_username" {
  description = "Database username"
  type        = string
    default = "admin"
}

variable "db_password" {
  description = "Database password"
  type        = string
  default = "Imran2025"
}

variable "aws_db_instance_engine_version" {
  description = "Database engine version"
  type        = string
  default = "8.0"
}

variable "db_subnet_group_name" {
  type    = string
  default = "main-db-subnet-group"
  description = "The name of the DB subnet group."
}