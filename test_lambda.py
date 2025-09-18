import json
from unittest.mock import patch
from lambda_function import lambda_handler

# Mock DynamoDB table behavior
class MockTable:
    def __init__(self):
        self.visits = 0

    def get_item(self, Key):
        return {"Item": {"count": self.visits}}

    def update_item(self, **kwargs):
        # kwargs contains ExpressionAttributeValues, Key, etc.
        self.visits += kwargs["ExpressionAttributeValues"][":inc"]
        return {"Attributes": {"count": self.visits}}

mock_table = MockTable()

# Patch environment variable and DynamoDB Table for GET test
@patch.dict("os.environ", {"TABLE_NAME": "mock_table"})
@patch("lambda_function.dynamodb.Table", return_value=mock_table)
def test_get_visits(mock_dynamo):
    event = {"requestContext": {"http": {"method": "GET"}}}
    result = lambda_handler(event, None)
    body = json.loads(result["body"])

    assert result["statusCode"] == 200
    assert "visit_count" in body
    assert body["visit_count"] == mock_table.visits

# Patch environment variable and DynamoDB Table for POST test
@patch.dict("os.environ", {"TABLE_NAME": "mock_table"})
@patch("lambda_function.dynamodb.Table", return_value=mock_table)
def test_post_visits(mock_dynamo):
    event = {"requestContext": {"http": {"method": "POST"}}}
    old_visits = mock_table.visits
    result = lambda_handler(event, None)
    body = json.loads(result["body"])

    assert result["statusCode"] == 201
    # Verify the visit count was incremented
    assert mock_table.visits == old_visits + 1
