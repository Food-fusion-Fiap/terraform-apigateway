resource "aws_api_gateway_rest_api" "food_fusion_apigateway" {
  name = "food-fusion-api-gateway"
  //body = file("${path.module}/doc.json")
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
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "integration" {
  rest_api_id             = aws_api_gateway_rest_api.food_fusion_apigateway.id
  resource_id             = aws_api_gateway_resource.authenticate.id
  http_method             = aws_api_gateway_method.authenticate_method.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.lambda_auth.invoke_arn
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
    resources = [aws_api_gateway_rest_api.food_fusion_apigateway.execution_arn]
  }
}

resource "aws_api_gateway_rest_api_policy" "apigateway_policy" {
  rest_api_id = aws_api_gateway_rest_api.food_fusion_apigateway.id
  policy      = data.aws_iam_policy_document.food_fusion_policy.json
}