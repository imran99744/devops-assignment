variable "aws_region" {
  description = "The AWS region to deploy resources in"
  type        = string
  default     = "us-east-1"
}

variable "s3_bucket_name" {
  description = "The name of the S3 bucket for storing Terraform state"
  type        = string
  default     = "my-tf-ecom-eks-state-bucket"
}

variable "enable_versioning" {
  description = "Enable or disable versioning for the S3 bucket"
  type        = string
  default     = "Enabled"
}

variable "sse_algorithm" {
  description = "The encryption algorithm for the S3 bucket"
  type        = string
  default     = "AES256"
}

variable "dynamodb_table_name" {
  description = "The name of the DynamoDB table for Terraform state locking"
  type        = string
  default     = "terraform-eks-state-locks"
}
