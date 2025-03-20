terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  required_version = ">= 1.2.0"
}

provider "aws" {
  region = var.aws_region
}

/*************** VPC Module *****************/
module "vpc" {
  source = "./modules/vpc"
  
  vpc_cidr           = var.vpc_cidr
  public_subnet_cidr = var.public_subnet_cidr
  private_subnet_cidr = var.private_subnet_cidr
  availability_zone  = var.availability_zone
}

/*************** Security Groups Module *****************/
module "security_groups" {
  source = "./modules/security_groups"
  
  vpc_id = module.vpc.vpc_id
}

/*************** EC2 Instance Module *****************/
module "ec2" {
  source = "./modules/ec2"
  
  subnet_id         = module.vpc.public_subnet_id
  security_group_id = module.security_groups.ec2_security_group_id
  instance_type     = var.ec2_instance_type
  key_name         = var.key_name
}

/*************** RDS Instance Module *****************/
module "rds" {
  source = "./modules/rds"
  
  subnet_id         = module.vpc.private_subnet_id
  security_group_id = module.security_groups.rds_security_group_id
  instance_class    = var.rds_instance_class
  db_name          = var.db_name
  db_username      = var.db_username
  db_password      = var.db_password
}