# allow the lambda service to assume roles
data "aws_iam_policy_document" "assume_role" {
  statement {
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
  }
}

# allow lambda to work with dynamodb
data "aws_iam_policy_document" "lambda_dynamodb" {
  statement {
    effect    = "Allow"
    actions   = ["dynamodb:*"]
    resources = ["arn:aws:dynamodb:*:*:*"]
  }
}

data "aws_iam_policy_document" "lambda_cloudwatch" {
  statement {
    effect    = "Allow"
    actions   = ["logs:*"]
    resources = ["arn:aws:logs:*:*:*"]
  }
}

# create role and attach assume policy
resource "aws_iam_role" "iam_for_lambda" {
  name               = "iam_for_lambda"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

# create a policy from the policy doc
resource "aws_iam_policy" "lambda_dynamodb" {
  name        = "lambda_dynamodb_policy"
  description = "Used to give lambda permissions to make calls on DynamoDB"
  policy      = data.aws_iam_policy_document.lambda_dynamodb.json
}

resource "aws_iam_policy" "lambda_logging_policy" {
  name        = "lambda_logging_policy"
  description = "Used to give lambda permissions to log to CloudWatch"
  policy      = data.aws_iam_policy_document.lambda_cloudwatch.json
}

resource "aws_iam_role_policy_attachment" "lambda_logging" {
  role       = aws_iam_role.iam_for_lambda.name
  policy_arn = aws_iam_policy.lambda_logging_policy.arn
}

# attach the policy to the lambda role
resource "aws_iam_role_policy_attachment" "lambda_dynamodb" {
  role       = aws_iam_role.iam_for_lambda.name
  policy_arn = aws_iam_policy.lambda_dynamodb.arn
}





