data "aws_caller_identity" "current" {}

data "terraform_remote_state" "rds_state" {
  backend = "s3"

  config = {
    bucket = var.s3_bucket_name
    key    = "prod/terraform-postgres.tfstate"
    region = "us-east-1"
  }
}

locals {
  aws_vpc_id            = data.terraform_remote_state.rds_state.outputs.vpc_id
  aws_public_subnet_id  = data.terraform_remote_state.rds_state.outputs.public_subnet_id
  aws_private_subnet_id = data.terraform_remote_state.rds_state.outputs.private_subnet_id
  aws_rds_public_sg_id  = data.terraform_remote_state.rds_state.outputs.rds_public_sg_id
}

data "aws_security_group" "lambda_auth_sg" {
  filter {
    name   = "group-name"
    values = ["lambda_auth_sg"]
  }
}

data "aws_iam_role" "lambda_role" {
  name = var.lambda_role_name
}

data "aws_lambda_function" "lambda_auth" {
  function_name = var.lambda_function_name
}
