data "terraform_remote_state" "rds_state" {
  backend = "s3"

  config = {
    bucket = "terraform-state-group-18"
    key    = "prod/terraform-postgres.tfstate"
    region = "us-east-1"
  }
}

locals {
  aws_vpc_id = data.terraform_remote_state.rds_state.outputs.vpc_id
  aws_public_subnet = data.terraform_remote_state.rds_state.outputs.public_subnet
  aws_private_subnet = data.terraform_remote_state.rds_state.outputs.private_subnet
  aws_rds_public_sg = data.terraform_remote_state.rds_state.outputs.rds_public_sg
}