variable "vpc_id" {
  description = "ID of the VPC"
  type        = string
}

variable "ec2_security_group_name" {
  type    = string
  default = "ec2-security-group"
  description = "Name of the EC2 security group."
}

variable "rds_security_group_name" {
  type    = string
  default = "rds-security-group"
  description = "Name of the RDS security group."
}