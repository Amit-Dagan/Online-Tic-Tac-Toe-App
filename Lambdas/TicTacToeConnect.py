import boto3
import json
import os

 
client = boto3.client('cognito-idp')

def lambda_handler(event, context):

    

    query_string_parameters = event.get("queryStringParameters", {})

    connectionId = event["requestContext"]["connectionId"]
    print(connectionId)
    # Extract the 'authorizationToken' parameter from the query string
    token = query_string_parameters.get("authorizationToken", "")
    
    # Now you have the authorizationToken value
    
    #print("authorizationToken:", token)

    dynamodb = boto3.resource("dynamodb")
    
    table_name = "TicTacToeActivePlayers"
    table = dynamodb.Table(table_name)

    
    statusCode = 200

    try:
        response = client.get_user(
            AccessToken = token
        )
        statusCode = 200
        
        item = {
            "connectionId": connectionId
        }
        
        table.put_item(Item = item)

    except:
        print("no access token")
        statusCode = 400        

    
    
    return {
        'statusCode': statusCode,
        'body': json.dumps('Hello from Lambda!')
    }
