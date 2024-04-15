import boto3
import time
from datetime import datetime

def lambda_handler(event, context):
    glue_client = boto3.client('glue')
    logs_client = boto3.client('logs')

    job_name = event.get('job_name', None)
    if job_name is None:
        raise ValueError("El nombre del trabajo no ha sido proporcionado en el evento.")

    start_response = glue_client.start_job_run(JobName=job_name)
    job_run_id = start_response['JobRunId']
    print(f"Job Run ID: {job_run_id} started for job: {job_name}")

    log_group_name = 'cloudwatch_log_group'

    start_time = datetime.now()
    tiempo = int(start_time.timestamp() * 1000)

    while True:
        job_run_response = glue_client.get_job_run(JobName=job_name, RunId=job_run_id)
        job_run_state = job_run_response['JobRun']['JobRunState']

        if job_run_state in ['STOPPING', 'SUCCEEDED', 'FAILED']:
            print(f"El trabajo {job_name} se ha completado con estado: {job_run_state}")
            return

        log_events = logs_client.filter_log_events(
            logGroupName=log_group_name,
            startTime=tiempo
        )

        if 'events' in log_events:
            for event in log_events['events']:
                message = event['message'].strip()
                print(f"Log message: {message}")

        time.sleep(5) 

    return

