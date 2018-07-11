variable "region" {
  type        = "string"
  description = "Choose the region"
  default     = "ap-south-1"
}

variable "subnet_cidr" {
  type    = "list"
  default = ["10.20.1.0/24", "10.20.2.0/24", "10.20.3.0/24"]
}

variable "ec2_ami" {
  default = "ami-5a8da735"
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

variable "webservers_azs" {
  default = ["ap-south-1a", "ap-south-1b"]
}

variable "public_subnets_count" {
  default = "2"
}
