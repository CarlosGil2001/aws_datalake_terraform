import boto3
import time

def lambda_handler(event, context):
    glue = boto3.client('glue')
    athena = boto3.client('athena')
    s3 = boto3.client('s3')
    
    old_table_name = event.get('old_table_name')
    new_table_name = event.get('new_table_name')

    database_name = 'dev_aws_data'
    output_location = 's3://bk-athenaresult-project1-dev-useast1/'

    try:
        response = glue.get_table(
            DatabaseName=database_name,
            Name=new_table_name
        )
        
        table_exists = True
    except glue.exceptions.EntityNotFoundException:
        table_exists = False
        response = glue.get_table(
            DatabaseName=database_name,
            Name=old_table_name
        )
        
        table_input = response['Table']
        table_input['Name'] = new_table_name

        del table_input['DatabaseName']
        del table_input['CreateTime']
        del table_input['UpdateTime']
        del table_input['CreatedBy']
        del table_input['IsRegisteredWithLakeFormation']
        del table_input['CatalogId']
        del table_input['VersionId']

        glue.create_table(
            DatabaseName=database_name,
            TableInput=table_input
        )

    if table_exists:
        print(f"La tabla {old_table_name} ya existe en el catálogo de Glue.")
    else:
        print(f"La tabla {old_table_name} ha sido creada correctamente.")
        
    query = f"INSERT INTO {new_table_name} SELECT * FROM {old_table_name};"

    response = athena.start_query_execution(
        QueryString=query,
        QueryExecutionContext={'Database': database_name},
        ResultConfiguration={'OutputLocation': output_location}
    )

    query_execution_id = response['QueryExecutionId']

    while True:
        query_status = athena.get_query_execution(QueryExecutionId=query_execution_id)
        state = query_status['QueryExecution']['Status']['State']
        
        if state == 'SUCCEEDED':
            print("Consulta exitosa")
            break
        elif state == 'FAILED':
            error_reason = query_status['QueryExecution']['Status']['StateChangeReason']
            print(f"Consulta fallida: {error_reason}")
            
            if "SYNTAX_ERROR" in error_reason:
                print("Error de sintaxis en la consulta SQL")
            elif "PERMISSION_DENIED" in error_reason:
                print("No tiene permisos para ejecutar la consulta")
            
            return {
                "statusCode": 500,
                "body": f"La consulta falló: {error_reason}"
            }
        else:
            print(f"Esperando a que la consulta termine... Estado actual: {state}")
            time.sleep(5)  

    try:
        glue.delete_table(
            DatabaseName=database_name,
            Name=old_table_name
        )
        print("La tabla 'old' ha sido eliminada correctamente.")
    except glue.exceptions.EntityNotFoundException:
        print("La tabla 'old' no existe en el catálogo de Glue.")

    return {
        "statusCode": 200,
        "body": "Proceso completado exitosamente."
    }