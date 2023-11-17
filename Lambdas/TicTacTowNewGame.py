import json
import urllib3
import boto3
import os

endpoint_url= os.environ.get('API_LINK')
client = boto3.client('apigatewaymanagementapi', endpoint_url)



def lambda_handler(event, context):
    # TODO implement

    connectionId = event["requestContext"]["connectionId"]
    body = json.loads(event["body"])

    code = body["code"]
    print(body)
 



    dynamodb = boto3.resource("dynamodb")
    
    table_name = "TicTacToeGames"
    games_table = dynamodb.Table(table_name)
    activePlayersTable = dynamodb.Table("TicTacToeActivePlayers")

    
    responce = games_table.get_item(Key= {"code": code})

    if "Item" in responce:
        return {
        'statusCode': 200,
        'code': 'taken'
    }
         

    else:
        item_for_games_table = {
            "code": code,
            "player1": connectionId,
            "board": [' ',' ',' ',' ',' ',' ',' ',' ',' '],
            "game started": False
        }
        games_table.put_item(Item = item_for_games_table)
        
        item_for_activePlayersTable = {
            "connectionId": connectionId,
            "code": code,
        }
        activePlayersTable.put_item(Item = item_for_activePlayersTable)
        responseMessage = "wating for the other player"
        data = {
            "responseMessage": responseMessage,
            "board": item_for_games_table["board"],
            "game started": item_for_games_table["game started"]
        }
        
    



    # Convert data dictionary to bytes
    data_bytes = json.dumps(data).encode('utf-8')
    
    # Form response and post back to connectionId
    client.post_to_connection(ConnectionId=connectionId, Data=data_bytes)
        
    
    
    return {
        'statusCode': 200
    }
 