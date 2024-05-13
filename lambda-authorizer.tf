resource "aws_lambda_function" "lambda_authorizer" {
  filename      = "lambda-auth/dist/lambda_function.zip"
  source_code_hash = filebase64("lambda-auth/dist/lambda_function.zip")
  function_name = "food-fusion-authorizer"
  role          = aws_iam_role.lambda_role.arn
  handler       = "app/authorizer.handler"
  runtime       = "nodejs20.x"
  timeout       = 5
  memory_size   = 128

  environment {
    variables = {
      NODE_ENV          = "production"
      /*RDS_ENDPOINT      = data.aws_ssm_parameter.db_host.value
      RDS_DATABASE_NAME = data.aws_ssm_parameter.db_name.value
      RDS_USER          = data.aws_ssm_parameter.db_username.value
      RDS_PASSWORD      = data.aws_ssm_parameter.db_password.value
      falta o secret jwt
      */
    }
  }

  vpc_config {
    subnet_ids         = [local.aws_public_subnet_id, local.aws_private_subnet_id]
    security_group_ids = [aws_security_group.lambda_auth_sg.id]
  }
}
