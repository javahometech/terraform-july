variable "region" {
  type        = "string"
  description = "Choose the region"
  default     = "us-east-1"
}

variable "web_ami" {
  type = "map"

  default = {
    ap-south-1 = "ami-5a8da735"
    us-east-1  = "ami-cfe4b2b0"
  }
}

variable "subnet_cidr" {
  type    = "list"
  default = ["10.20.1.0/24", "10.20.2.0/24", "10.20.3.0/24"]
}

variable "ec2_instance_type" {
  default = "t2.micro"
}

variable "ec2_keyname" {
  default = "hari"
}

# Variable for VPC
variable "vpc_cidr" {
  default = "192.50.0.0/16"
}

variable "vpc_tenency" {
  default = "default"
}

# Variables for public subnets
variable "cidr_webservers" {
  type    = "list"
  default = ["192.50.1.0/24", "192.50.2.0/24"]
}

# Declare the data source
data "aws_availability_zones" "azs" {}

variable "public_subnets_count" {
  default = "2"
}

# Variables for RDS and private subnets
variable "db_sub_count" {
  default = "2"
}

variable "cidr_rds" {
  type    = "list"
  default = ["192.50.3.0/24", "192.50.4.0/24"]
}

variable "web_servers_count" {
  default = "2"
}
