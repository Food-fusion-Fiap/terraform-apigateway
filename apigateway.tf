resource "aws_api_gateway_rest_api" "food_fusion_apigateway" {
  name = "food-fusion-api-gateway"
  body = templatefile("${path.module}/doc.json", { authorizer_uri = local.lambda_authorizer_invoke_arn, load_balancer_uri = local.eks_cluster_endpoint })

  put_rest_api_mode = "merge"
}

resource "aws_api_gateway_resource" "authenticate" {
  rest_api_id = aws_api_gateway_rest_api.food_fusion_apigateway.id
  parent_id   = aws_api_gateway_rest_api.food_fusion_apigateway.root_resource_id
  path_part   = "authenticate"
}

resource "aws_api_gateway_method" "authenticate_method" {
  rest_api_id   = aws_api_gateway_rest_api.food_fusion_apigateway.id
  resource_id   = aws_api_gateway_resource.authenticate.id
  http_method   = "GET"
  authorization = "AWS_IAM"
}

resource "aws_api_gateway_integration" "integration" {
  rest_api_id             = aws_api_gateway_rest_api.food_fusion_apigateway.id
  resource_id             = aws_api_gateway_resource.authenticate.id
  http_method             = aws_api_gateway_method.authenticate_method.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = data.aws_lambda_function.lambda_auth.invoke_arn
}

resource "aws_api_gateway_deployment" "food_fusion_deployment" {
  rest_api_id = aws_api_gateway_rest_api.food_fusion_apigateway.id

  triggers = {
    redeployment = sha1(jsonencode(aws_api_gateway_rest_api.food_fusion_apigateway.body))
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_stage" "food_fusion_stage_deployment" {
  deployment_id = aws_api_gateway_deployment.food_fusion_deployment.id
  rest_api_id   = aws_api_gateway_rest_api.food_fusion_apigateway.id
  stage_name    = "Food_fusion_test_deployment_stage"
}

/**************************************************************/
data "aws_iam_policy_document" "food_fusion_policy" {
  statement {
    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }

    actions   = ["execute-api:Invoke"]
    resources = ["*"]
  }
}

resource "aws_api_gateway_rest_api_policy" "apigateway_policy" {
  rest_api_id = aws_api_gateway_rest_api.food_fusion_apigateway.id
  policy      = data.aws_iam_policy_document.food_fusion_policy.json
}
