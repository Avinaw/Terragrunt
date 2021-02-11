variable "aws_region" {
  description = "The AWS region to deploy to (e.g. us-east-1)"
  default = "us-east-1"
  type = string
}

variable "name" {
  description = "The name of the DB"
  default = "Test"
  type = string
}

variable "instance_class" {
  description = "The instance class of the DB (e.g. db.t2.micro)"
  default = "db.t2.micro"
  type = string
}

variable "allocated_storage" {
  description = "The amount of space, in GB, to allocate for the DB"
  type = number
  default = 30
}

variable "storage_type" {
  description = "The type of storage to use for the DB. Must be one of: standard, gp2, or io1."
  type = string
  default = "standard"
}

variable "master_username" {
  description = "The username for the master user of the DB"
  type = string
  default = "root"
}

variable "master_password" {
  description = "The password for the master user of the DB"
  type = string
  default = "root"
}

# ---------------------------------------------------------------------------------------------------------------------
# A SIMPLE EXAMPLE OF HOW TO DEPLOY MYSQL ON RDS
# This is an example of how to use Terraform to deploy a MySQL database on Amazon RDS.
#
# Note: This code is meant solely as a simple demonstration of how to lay out your files and folders with Terragrunt
# in a way that keeps your Terraform code DRY. This is not production-ready code, so use at your own risk.
# ---------------------------------------------------------------------------------------------------------------------
terraform {
    # Live modules pin exact Terraform version; generic modules let consumers pin the version.
    # The latest version of Terragrunt (v0.25.1 and above) recommends Terraform 0.13.3 or above.
  required_version = "= 0.13.3"
    # Live modules pin exact provider version; generic modules let consumers pin the version.
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "= 3.7.0"
    }
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# CREATE THE MYSQL DB
# ---------------------------------------------------------------------------------------------------------------------
resource "aws_db_instance" "mysql" {
  engine = "mysql"
  engine_version = "5.6.41"
  name = var.name
  username = var.master_username
  password = var.master_password
  instance_class = var.instance_class
  allocated_storage = var.allocated_storage
  storage_type = var.storage_type
    # TODO: DO NOT COPY THIS SETTING INTO YOUR PRODUCTION DBS. It's only here to make testing this code easier!
  skip_final_snapshot = true
}

output "endpoint" {
  value = aws_db_instance.mysql.endpoint
}

output "db_name" {
  value = aws_db_instance.mysql.name
}

output "arn" {
  value = aws_db_instance.mysql.arn
}

module "ec2-instance" {
  source = "terraform-aws-modules/ec2-instance/aws"
  version = "2.16.0"
    # A number of IPv6 addresses to associate with the primary network interface. Amazon EC2 chooses the IPv6 addresses from the range of your subnet.
  ipv6_address_count = 1
    # Can be used instead of user_data to pass base64-encoded binary data directly. Use this instead of user_data whenever the value is not a valid UTF-8 string. For example, gzip-encoded user data must be base64-encoded and passed via this argument to avoid corruption.
  user_data_base64 = ""
    # The user data to provide when launching the instance. Do not pass gzip-compressed data via this argument; see user_data_base64 instead.
  user_data = ""
    # Specify one or more IPv6 addresses from the range of the subnet to associate with the primary network interface
  ipv6_addresses = [  ]
    # Private IP address to associate with the instance in a VPC
  private_ip = ""
    # Name to be used on all resources as prefix
  name = ""
    # If true, the EC2 instance will have associated public IP address
  associate_public_ip_address = true
    # A list of security group IDs to associate with
  vpc_security_group_ids = [  ]
    # The type of instance to start
  instance_type = ""
    # ID of AMI to use for the instance
  ami = ""
}

resource "aws_cloudformation_stack" "cloudformation_stack" {
  name = 
}

resource "aws_eks_fargate_profile" "eks_fargate_profile" {
  selector {
    namespace = 
  }
  cluster_name = 
  fargate_profile_name = 
  pod_execution_role_arn = 
}

resource "aws_eip" "eip" {}
