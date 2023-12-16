data "archive_file" "lambda" {
  type        = "zip"
  source_dir  = "../src/lambdas/spaces"
  output_path = "../src/lambdas/spaces/handler.zip"
}

resource "aws_lambda_function" "spaces" {
  function_name    = "spaces"
  runtime          = "nodejs18.x"
  handler          = "handler.handler"
  filename         = "../src/lambdas/spaces/handler.zip"
  role             = aws_iam_role.iam_for_lambda.arn
  depends_on       = [aws_cloudwatch_log_group.spaces]
  source_code_hash = data.archive_file.lambda.output_base64sha256
}