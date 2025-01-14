provider "aws" {
  region = "us-east-1" # Change the region as needed
}

terraform {
  backend "s3" {
    bucket = "tfremote2344"
    key    = "terraform.tfstate"
    region = "eu-west-1"
  }
}