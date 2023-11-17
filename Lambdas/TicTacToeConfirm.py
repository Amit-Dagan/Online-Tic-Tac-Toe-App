import json
import boto3
from botocore.exceptions import ClientError
import os

client = boto3.client('cognito-idp')
clientId = os.environ.get('CLIENT_ID')

def lambda_handler(event, context):
    
    
    
    mail = event["USERNAME"]
    confirmationCode = event["CODE"]


    response = sign_up(mail, confirmationCode)
    print(response)
    return(response)


def sign_up(mail, confirmationCode):
    try: 
        response = client.confirm_sign_up(
            ClientId = clientId,
            Username = mail,
            ConfirmationCode = confirmationCode
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
