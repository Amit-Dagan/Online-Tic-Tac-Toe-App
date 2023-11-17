import json
import boto3

 
client = boto3.client('cognito-idp')

def lambda_handler(event, context):

    connectionId = event["requestContext"]["connectionId"]
    print(connectionId)
    dynamodb = boto3.resource("dynamodb")
    
    table_players = dynamodb.Table("TicTacToeActivePlayers")
    table_games =  dynamodb.Table("TicTacToeGames") 
    
    statusCode = 200

    responce = table_players.get_item(Key={"connectionId": connectionId})
    
    if "Item" in responce:
        item = responce["Item"]
        print(item)
        if "code" in item:
            code = item["code"]
            table_games.delete_item(Key={"code": code})

        
    table_players.delete_item(Key={"connectionId": connectionId})
    
    
    return {
        'statusCode': statusCode,
        'body': json.dumps('Hello from Lambda!')
    }
