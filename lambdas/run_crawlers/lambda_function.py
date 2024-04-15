import boto3
import time
from datetime import datetime

def lambda_handler(event, context):
    glue_client = boto3.client('glue')
    logs_client = boto3.client('logs')

   #crawler_name = 'dev_crw_bronzezone'
    crawler_name = event.get('crawler_name', None)
    if crawler_name is None:
        raise ValueError("El nombre del crawler no ha sido proporcionado en el evento.")
    
    start_time = datetime.now()
    glue_client.start_crawler(Name=crawler_name)

    log_group_name = '/aws-glue/crawlers'

    tiempo = int(start_time.timestamp() * 1000)
    
    while True:
        crawler_response = glue_client.get_crawler(Name=crawler_name)
        crawler_state = crawler_response['Crawler']['State']

        if crawler_state == 'STOPPING':
            print('El Crawler se ejecutó correctamente.')
            return state
        elif crawler_state == 'FAILED':
            print('El Crawler falló durante la ejecución.')
            return

        log_events = logs_client.filter_log_events(
            logGroupName=log_group_name,
            startTime=tiempo  
        )

        if 'events' in log_events:
            for event in log_events['events']:
                message = event['message'].strip()
                if 'Crawler has finished running and is in state READY' in message:
                    print('El Crawler se ejecutó correctamente.')
                    return state
                elif 'Crawler execution failed' in message:
                    print('El Crawler falló durante la ejecución.')
                    return

        time.sleep(5) 