import json
import boto3
import urllib3
import os

 
endpoint_url= os.environ.get('API_LINK')
client = boto3.client('apigatewaymanagementapi', endpoint_url)


def lambda_handler(event, context):

    print(event)
    connectionId = event["requestContext"]["connectionId"]
    body = json.loads(event["body"])
    code = body["code"]
    place = body["place"]
    
    dynamodb = boto3.resource("dynamodb")
    
    table_name = "TicTacToeGames"
    table = dynamodb.Table(table_name)


    responce = table.get_item(Key= {"code": code})
    player_won = 0

    if "Item" in responce:
        item = responce["Item"]
        #play
        if connectionId != item["turn"]:
            responseMessage = "Its not your turn"
            
        elif item["board"][place] != " ":
            responseMessage = "Choose empty place"
            
        else:
            item["board"][place] = "X" if item["x"] == connectionId else "O"
            player_won = won(item["board"])
            if player_won == " ":
                responseMessage = "OK"
                item["turn"] = item["player1"] if item["turn"] == item["player2"] else item["player2"]
                table.put_item(Item = item)
            else:
                responseMessage = "you has won!"
    
        data = {
        "responseMessage": responseMessage,
        "board": item["board"],
        "turn": item["turn"],
        "game started": item["game started"]
        }
        
        # Convert data dictionary to bytes
        data_bytes = json.dumps(data).encode('utf-8')
        
        # Form response and post back to connectionId
        client.post_to_connection(ConnectionId=item["player1"], Data=data_bytes)
        client.post_to_connection(ConnectionId=item["player2"], Data=data_bytes)

    else:
        
        responseMessage = "No room in that name. Try to create a new room"
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
        'body': json.dumps('Hello from Lambda!')
    }

def won(board):
    #check vertically
    for i in range(0,2):
        if board[0+i] == board[3+i] == board[6+i] and board[0+i] != " ":
            return board[0+i]
    #check horizontally 
    for i in range(0, 7, 3):
        if board[0+i] == board[1+i] == board[2+i] and board[0+i] != " ":
            return board[0+i]
    #check diagonally
    if board[0] == board[4] == board[8] and board[0] != " ":
        return(board[0])
    if board[2] == board[4] == board[6] and board[2] != " ":
        return(board[2])
    
    return(" ") 