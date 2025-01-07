provider "aws" {
  region = "eu-west-1" # Replace with your region
}

terraform {
 backend "s3" {
 bucket = "tfremote2344"
 key = "terraform.tfstate"
 region = "eu-west-1"
 }
}