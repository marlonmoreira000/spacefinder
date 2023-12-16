resource "aws_cloudwatch_log_group" "spaces" {
  name              = "/aws/lambda/spaces"
  retention_in_days = 7
  lifecycle {
    prevent_destroy = false
  }
}