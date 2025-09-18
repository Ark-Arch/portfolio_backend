resource "aws_dynamodb_table" "visitor_count" {
    name = "cloud-resume-visitor-count" # the name as it is provisioned on aws
    billing_mode = "PAY_PER_REQUEST" # on-demand pricing which is free-tier friendly
    hash_key = "id" # a must define primary key

    attribute {
        name = "id"
        type = "S"
    }
}

# notes:
# with the above, i have successully created a dynamo table on aws_dynamodb_table
# of cource, dynamodb is schemaless, and it is separated by the hash_key - primary key.
# there are two types of primary keys - hash key (partition key only) AND composite key (partition + sort key).

# as for the definition of the initial row needed - where id=visits, count=0