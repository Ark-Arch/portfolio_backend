# using the http api

# create the api gateway itself
resource "aws_apigatewayv2_api" "visitor_api" {
  name = "cloud-resume-visitor-api"
  protocol_type = "HTTP"
}

# to integrate the gateway with lambda
resource "aws_apigatewayv2_integration" "lambda_integration" {
    api_id = aws_apigatewayv2_api.visitor_api.id
    integration_type = "AWS_PROXY"
    integration_uri = aws_lambda_function.visitor_counter.arn # the endpoint it hits - the lambda function resource
    integration_method = "POST"
    payload_format_version = "2.0"
}

# to create a route (/visitors)
resource "aws_apigatewayv2_route" "visitor_route" {
    api_id = aws_apigatewayv2_api.visitor_api.id
    route_key = "ANY /visitors" # since error handling already at the point of lambda invocation.
    target = "integrations/${aws_apigatewayv2_integration.lambda_integration.id}"
}

# deployment + stage
resource "aws_apigatewayv2_stage" "default_stage" {
    api_id = aws_apigatewayv2_api.visitor_api.id
    name = "$default"
    auto_deploy = true  
}

# permission by lambda to allow api gateway to invoke it 
resource "aws_lambda_permission" "apigw_invoke" {
    statement_id = "AllowAPIGatewayInvoke"
    action = "lambda:InvokeFunction"
    function_name = aws_lambda_function.visitor_counter.function_name
    principal = "apigateway.amazonaws.com"
    source_arn = ""
}