import boto3 # aws sdk for python - it allows communication with dynamodb
import json # this converts python dictionaries into JSON strings as needed for HTTP API responses
import os # this is used to read environment variables. 

# NOTES:
# the aim of this lambda script is to handle a get and post request from the api gateway to the database

dynamodb = boto3.resources("dynamodb")
table = dynamodb.Table(os.environ["TABLE_NAME"])

def lambda_handler(event, context):
    # if there is a GET request from the frontend through API
    if event["requestContext"]["http"]["method"] == "GET":
        response = table.get_item(Key={"id": "visits"}) # identifier is visits
        count = response.get("Item", {}).get("count", 0) # attribute is count
        return {
            "statusCode": 200,
            "headers": {"Content-Type": "application/json"},
            "body": json.dumps({"visit_count": count})
        }
    
    # if there is a POST Request from the frontend through the API gateway
    elif event["requestContext"]["http"]["method"] == "POST":
        response = table.update_item(
            Key={"id": "visits"},
            UpdateExpression="ADD count :inc",
            ExpressionAttributeValues={":inc": 1},
            ReturnValues="UPDATED_NEW"
        )
        return {
            "statusCode": 200,
            "headers": {"Content-Type": "application/json"},
            "body": json.dumps({"visit_count": response["Attributes"]["count"]})
        }
    
    # error handling for situations where any other different api request is made
    else:
        return {
            "statusCode": 405,
            "body": json.dumps({"error": "Method Not Allowed"})
        }
