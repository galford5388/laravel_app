# remove all the hardcoded value and create it in terraform cloud

# Terraform Cloud workspace configuration
terraform {
  backend "remote" {
    organization = "ORGANIZATION"

    workspaces {
      name = "WORKSPACE"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

variable "aws_region" {
  description = "List of subnet IDs for ALB and ECS service"
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs for ALB and ECS service"
  type        = list(string)
}

variable "vpc_id" {
  description = "VPC ID for the target group"
  type        = string
}

variable "security_group_ids" {
  description = "List of security group IDs for ECS service"
  type        = list(string)
}

variable "db_instance_class" {
  description = "Database instance class"
  type        = string
  default     = "db.t2.micro"
}

variable "db_engine_version" {
  description = "Database engine version"
  type        = string
  default     = "8.0"
}

variable "db_username" {
  description = "Database username"
  type        = string
  default     = "admin"
}

variable "db_password" {
  description = "Database password"
  type        = string
  default     = "password"
}
