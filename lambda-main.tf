resource "aws_security_group" "lambda_auth_sg" {
  name   = "lambda_auth_sg"
  vpc_id = local.aws_vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_lambda_function" "lambda_auth" {
  filename      = "lambda/lambda_function2.zip"
  function_name = var.lambda_function_name
  role          = var.labRole
  handler       = "app/index.handler"
  runtime       = "nodejs20.x"
  timeout       = 10
  memory_size   = 128

  environment {
    variables = {
      NODE_ENV = "production"
    }
  }

  vpc_config {
    subnet_ids         = [local.aws_public_subnet.id, local.aws_private_subnet.id]
    security_group_ids = [aws_security_group.lambda_auth_sg.id]
  }
}

resource "aws_security_group_rule" "lambda_to_rds" {
  type                     = "ingress"
  from_port                = 5432 # Porta do banco de dados na instância RDS
  to_port                  = 5432 # Porta do banco de dados na instância RDS
  protocol                 = "tcp"
  security_group_id        = local.aws_rds_public_sg.id # ID da security group da RDS
  source_security_group_id = aws_security_group.lambda_auth_sg.id     # ID da security group da Lambda
}

resource "aws_security_group_rule" "lambda_to_rds_again" {
  type                     = "egress"
  from_port                = 5432 # Porta do banco de dados na instância RDS
  to_port                  = 5432 # Porta do banco de dados na instância RDS
  protocol                 = "tcp"
  security_group_id        = local.aws_rds_public_sg.id # ID da security group da RDS
  source_security_group_id = aws_security_group.lambda_auth_sg.id     # ID da security group da Lambda
}

resource "aws_lambda_permission" "apigw_lambda" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda_auth.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "arn:aws:execute-api:${var.regionDefault}:${var.accountId}:${aws_api_gateway_rest_api.food_fusion_apigateway.id}/*/${aws_api_gateway_method.authenticate_method.http_method}${aws_api_gateway_resource.authenticate.path}"
}

terraform {
  backend "s3" {
    bucket = "terraform-state-group-18"
    key    = "prod/lambda-auth.tfstate"
    region = "us-east-1"
  }
}
