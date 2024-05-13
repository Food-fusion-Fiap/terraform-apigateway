variable "regionDefault" {
  default = "us-east-1"
}

variable "accountId" {
  default = "211125364272"
}

variable "region" {
  description = "Região da AWS"
  default     = "us-east-1"
}

variable "lambda_function_name" {
  description = "Nome da função Lambda"
  default     = "food-fusion-auth"
}

variable "lambda_role_name" {
  description = "Nome do papel da função Lambda"
  default     = "food-fusion-auth-role"
}

variable "lambda_policy_attachment_name" {
  description = "Nome da política de anexo da função Lambda"
  default     = "food-fusion-auth-policy-attachment"
}

variable "s3_bucket_name" {
  default     = "terraform-state-fiap-group-18"
}

variable "project_name" {
  description = "The name of the project"
  default     = "food_fusion"
}

variable "jwt_secret" {
  description = "Chave secreta JWT"
  default     = ""
}