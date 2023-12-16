output "spaces_api_url" {
  description = "The URL of the API"
  value       = aws_api_gateway_deployment.spaces.invoke_url
}

output "stage_name" {
  description = "The stage for the API"
  value       = aws_api_gateway_stage.spaces.stage_name
}

output "path_part" {
  description = "The path part of the API"
  value       = aws_api_gateway_resource.spaces.path_part
}

output "full_url" {
  description = "The full URL for the API"
  value       = "${aws_api_gateway_deployment.spaces.invoke_url}${aws_api_gateway_stage.spaces.stage_name}/${aws_api_gateway_resource.spaces.path_part}"
}

