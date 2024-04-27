import boto3

def lambda_handler(event, context):

    step_function = boto3.client('stepfunctions')
    response = step_function.start_execution(
        stateMachineArn='arn_step_function',
        input='{}'
    )
    return {
        'statusCode': 200,
        'body': 'Step Function execution started'
    }
