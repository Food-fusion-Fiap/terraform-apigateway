provider "aws" {
  region  = var.regionDefault
}

terraform {
  backend "s3" {
    bucket = "terraform-state-fiap-group-18" //same as var.s3_bucket_name
    key    = "prod/lambda-auth.tfstate"
    region = "us-east-1"
  }
}
