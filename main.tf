provider "aws" {
  region = var.region
}

terraform {
  backend "s3" {
    bucket = "terraform-github-action" //same as var.s3_bucket_name
    key    = "prod/lambda-auth.tfstate"
    region = "us-east-1"
  }
}
