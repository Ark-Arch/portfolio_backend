output "visitor_table_name" {
      value = aws_dynamodb_table.visitor_count.name
}

output "visitor_api_endpoint" {
      description = "The base URL of the visitor API"
      value = aws_apigatewayv2_api.visitor_api.api_endpoint
}