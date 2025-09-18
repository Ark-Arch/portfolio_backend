# creating an iam role - temporary credential for my lambda functon

# create the temporary credential
resource "aws_iam_role" "lambda_role" {
    name = "cloud-resume-lambda-role"
    assume_role_policy = jsonencode({
        Version = "2012-10-17",
        Statement = [{
            Action = "sts:AssumeRole",
            Principal = {
                Service = "lambda.amazonaws.com"
            },
            Effect = "Allow",
        }]
    })
}

# create an attachment between the role and the lambda function
resource "aws_iam_policy_attachment" "lambda_dynamodb_attach" {
    name = "lambda-dynamodb-policy"
    roles = [aws_iam_role.lambda_role.name]
    policy_arn = "arn:aws:iam::aws:policy/AmazonDynamoDBFullAccess"
}

resource "aws_iam_policy_attachment" "lambda_logging" {
    name = "lambda-logging"
    roles = [aws_iam_role.lambda_role.name]
    policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}


# create the function
resource "aws_lambda_function" "visitor_counter" {
    function_name = "cloud-resume-visitor-counter"
    role = aws_iam_role.lambda_role.arn
    handler = "lambda_function.lambda_handler"
    runtime = "python3.12"

    filename = local.lambda_zip
    source_code_hash = filebase64sha256(local.lambda_zip)

    environment {
        variables = {
            TABLE_NAME = aws_dynamodb_table.visitor_count.name
        }
    }
}