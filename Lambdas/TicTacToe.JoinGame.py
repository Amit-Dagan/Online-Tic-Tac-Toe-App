import json
import urllib3
import boto3
import random
import os


endpoint_url= os.environ.get('API_LINK')
client = boto3.client('apigatewaymanagementapi', endpoint_url)


def lambda_handler(event, context):
    # TODO implement

    connectionId = event["requestContext"]["connectionId"]
    body = json.loads(event["body"])
    code = body["code"]
    
    print(event)
    



    dynamodb = boto3.resource("dynamodb")
    
    table_name = "TicTacToeGames"
    table = dynamodb.Table(table_name)
    
    responseMessage = "..."
    responce = table.get_item(Key= {"code": code})

    if "Item" in responce:
        item = responce["Item"]
        if item["player1"] == connectionId:
            responseMessage = "you need 2 different players"
        else:
            item["player2"] = connectionId
            item["game started"] = True
            item["x"] = random.choice([item["player2"], item["player1"]])
            item["turn"] = item["x"]
            responseMessage = "started a game"
            table.put_item(Item = item)

            data = {
                "responseMessage": responseMessage,
                "board": item["board"],
                "turn": item["turn"],
                "game started": item["game started"]
            }

        
    else:
        responseMessage = "There is no room named" + code + ". Try again"
        data = {
            "responseMessage": responseMessage,
            "game started": False
        }





    # Convert data dictionary to bytes
    data_bytes = json.dumps(data).encode('utf-8')
    
    # Form response and post back to connectionId
    client.post_to_connection(ConnectionId=connectionId, Data=data_bytes)
        
    
    return {
        'statusCode': 200,
    }
 