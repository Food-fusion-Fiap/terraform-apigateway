data "aws_caller_identity" "current" {}

data "terraform_remote_state" "lambda_state" {
  backend = "s3"
  config = {
    bucket = var.s3_bucket_name
    key    = "prod/terraform-lambda.tfstate"
    region = "us-east-1"
  }
}

data "terraform_remote_state" "eks_state" {
  backend = "s3"
  config = {
    bucket = var.s3_bucket_name
    key    = "prod/terraform-eks.tfstate"
    region = "us-east-1"
  }
}

locals {
  lambda_authorizer_invoke_arn = data.terraform_remote_state.lambda_state.outputs.lambda_authorizer_invoke_arn
  lambda_authenticate_function_name = data.terraform_remote_state.lambda_state.outputs.lambda_authenticate_function_name
  lambda_authorizer_function_name = data.terraform_remote_state.lambda_state.outputs.lambda_authorizer_function_name
  load_balancer_dns = data.terraform_remote_state.eks_state.outputs.load_balancer_dns
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