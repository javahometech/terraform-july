provider "aws" {
  region = "${var.region}"
}

terraform {
  backend "s3" {
    bucket = "jobassist"
    key    = "dev/terraform.tfstate"
    region = "ap-south-1"
  }
}
