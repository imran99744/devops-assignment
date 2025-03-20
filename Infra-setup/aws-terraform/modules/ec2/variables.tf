variable "instance_type" {
  description = "EC2 instance type"
  type        = string
}

variable "subnet_id" {
  description = "Subnet ID where the instance will be launched"
  type        = string
}

variable "security_group_id" {
  description = "Security group ID for the instance"
  type        = string
}

variable "key_name" {
  description = "Name of the SSH key pair"
  type        = string
}

variable "ami_name_pattern" {
  type    = string
  default = "amzn2-ami-hvm-*-x86_64-gp2"
  description = "The AMI name pattern to filter by."
}