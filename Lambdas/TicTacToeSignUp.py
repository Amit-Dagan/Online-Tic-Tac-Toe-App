import json
import boto3
from botocore.exceptions import ClientError
import os

client = boto3.client('cognito-idp')
clientId = os.environ.get('CLIENT_ID')

def lambda_handler(event, context):
    
    
    
    mail = event["USERNAME"]
    password = event["PASSWORD"]


    response = sign_up(mail, password)
    print(response)
    return(response)


def sign_up(mail, password):
    try: 
        response = client.sign_up(
            ClientId=clientId,
            Username=mail,
            Password=password
        )
        # User signup was successful
        return {
            'statusCode': 200,
            'body': 'User signed up successfully'
        }
    except ClientError as e:
        if e.response['Error']['Code'] == 'UsernameExistsException':
            print('Username already exists:', e)
            return {
                'statusCode': 400,  
                'body': 'Mail already exists'
            }
        else:
            print('An error occurred:', e)
            return {
                'statusCode': 500,  
                'body': 'An error occurred'
            }

    return response
