resource "aws_api_gateway_rest_api" "spaces" {
  name        = "spaces_api"
  description = "API to handle all requests to /spaces resource"
}

resource "aws_lambda_permission" "spaces" {
  principal     = "apigateway.amazonaws.com"
  statement_id  = "AllowLambdaExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.spaces.function_name
  source_arn    = "${aws_api_gateway_rest_api.spaces.execution_arn}/*/*"
}

resource "aws_api_gateway_resource" "spaces" {
  rest_api_id = aws_api_gateway_rest_api.spaces.id
  parent_id   = aws_api_gateway_rest_api.spaces.root_resource_id
  path_part   = "spaces"
}

resource "aws_api_gateway_resource" "spaces_id" {
  rest_api_id = aws_api_gateway_rest_api.spaces.id
  parent_id   = aws_api_gateway_resource.spaces.id
  path_part   = "{id}"
}

resource "aws_api_gateway_method" "get" {
  rest_api_id   = aws_api_gateway_rest_api.spaces.id
  resource_id   = aws_api_gateway_resource.spaces.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_method" "get_id" {
  rest_api_id   = aws_api_gateway_rest_api.spaces.id
  resource_id   = aws_api_gateway_resource.spaces_id.id
  http_method   = "GET"
  authorization = "NONE"
  request_parameters = {
    "method.request.path.id" = true
  }
}

resource "aws_api_gateway_integration" "get" {
  rest_api_id             = aws_api_gateway_rest_api.spaces.id
  resource_id             = aws_api_gateway_resource.spaces.id
  http_method             = aws_api_gateway_method.get.http_method
  type                    = "AWS_PROXY"
  integration_http_method = "POST"
  uri                     = aws_lambda_function.spaces.invoke_arn
}

resource "aws_api_gateway_integration" "get_id" {
  rest_api_id             = aws_api_gateway_rest_api.spaces.id
  resource_id             = aws_api_gateway_resource.spaces_id.id
  http_method             = aws_api_gateway_method.get_id.http_method
  type                    = "AWS_PROXY"
  integration_http_method = "POST"
  uri                     = aws_lambda_function.spaces.invoke_arn
  request_parameters = {
    "integration.request.path.id" = "method.request.path.id"
    }
}

# POST
resource "aws_api_gateway_method" "post" {
  rest_api_id   = aws_api_gateway_rest_api.spaces.id
  resource_id   = aws_api_gateway_resource.spaces.id
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "post" {
  rest_api_id             = aws_api_gateway_rest_api.spaces.id
  resource_id             = aws_api_gateway_resource.spaces.id
  http_method             = aws_api_gateway_method.post.http_method
  type                    = "AWS_PROXY"
  integration_http_method = "POST"
  uri                     = aws_lambda_function.spaces.invoke_arn
}

# UPDATE
resource "aws_api_gateway_method" "put_id" {
  rest_api_id   = aws_api_gateway_rest_api.spaces.id
  resource_id   = aws_api_gateway_resource.spaces.id
  http_method   = "PUT"
  authorization = "NONE"
  request_parameters = {
    "method.request.path.id" = true
  }
}

resource "aws_api_gateway_integration" "put_id" {
  rest_api_id             = aws_api_gateway_rest_api.spaces.id
  resource_id             = aws_api_gateway_resource.spaces.id
  http_method             = aws_api_gateway_method.put_id.http_method
  type                    = "AWS_PROXY"
  integration_http_method = "POST"
  uri                     = aws_lambda_function.spaces.invoke_arn
  request_parameters = {
    "integration.request.path.id" = "method.request.path.id"
    }
}

# DELETE
resource "aws_api_gateway_method" "delete_id" {
  rest_api_id   = aws_api_gateway_rest_api.spaces.id
  resource_id   = aws_api_gateway_resource.spaces.id
  http_method   = "DELETE"
  authorization = "NONE"
  request_parameters = {
    "method.request.path.id" = true
  }
}

resource "aws_api_gateway_integration" "delete_id" {
  rest_api_id             = aws_api_gateway_rest_api.spaces.id
  resource_id             = aws_api_gateway_resource.spaces.id
  http_method             = aws_api_gateway_method.delete_id.http_method
  type                    = "AWS_PROXY"
  integration_http_method = "POST"
  uri                     = aws_lambda_function.spaces.invoke_arn
  request_parameters = {
    "integration.request.path.id" = "method.request.path.id"
    }
}

resource "aws_api_gateway_deployment" "spaces" {
  rest_api_id = aws_api_gateway_rest_api.spaces.id

  triggers = {
    redeployment = sha1(jsonencode([
      aws_api_gateway_resource.spaces.id,
      aws_api_gateway_resource.spaces_id.id,
      aws_api_gateway_method.get.id,
      aws_api_gateway_method.get_id.id,
      aws_api_gateway_method.post.id,
      aws_api_gateway_method.put_id.id,
      aws_api_gateway_method.delete_id.id,
      aws_api_gateway_integration.get.id,
      aws_api_gateway_integration.get_id.id,
      aws_api_gateway_integration.post.id,
      aws_api_gateway_integration.delete_id.id,
      aws_api_gateway_integration.put_id.id,
    ]))
  }

  lifecycle {
    create_before_destroy = true
  }

  # depends_on = [
    # aws_api_gateway_method.get,
    # aws_api_gateway_integration.get,
    # aws_api_gateway_method.post,
    # aws_api_gateway_integration.post,
    # aws_api_gateway_method.put_id,
    # aws_api_gateway_integration.put_id,
    # aws_api_gateway_method.delete_id,
    # aws_api_gateway_integration.delete_id
  # ]
}

resource "aws_api_gateway_stage" "spaces" {
  deployment_id = aws_api_gateway_deployment.spaces.id
  rest_api_id   = aws_api_gateway_rest_api.spaces.id
  stage_name    = var.environment
}