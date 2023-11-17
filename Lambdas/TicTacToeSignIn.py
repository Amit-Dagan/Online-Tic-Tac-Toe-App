import json
import boto3
import os

client = boto3.client('cognito-idp')
clientId = os.environ.get('CLIENT_ID')

def lambda_handler(event, context):
    
    
    
    mail = event["AuthParameters"]["USERNAME"]
    password = event["AuthParameters"]["PASSWORD"]


    response = mail_password_sign_in(mail, password)

    print(response['AuthenticationResult'])
    return {
        'statusCode': 200,
        'body': response['AuthenticationResult']
    }


def mail_password_sign_in(mail, password):
        
    response = client.initiate_auth(
        AuthFlow='USER_PASSWORD_AUTH',
        AuthParameters={
            'USERNAME': mail,
            'PASSWORD': password
        },
    
        ClientId = clientId,
    )
    
    
    # Extract the tokens from the response
    
    return response
