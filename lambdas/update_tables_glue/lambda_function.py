import boto3
import time

def lambda_handler(event, context):
    glue = boto3.client('glue')
    
    old_table_name = event.get('old_table_name')
    new_table_name = event.get('new_table_name')

    database_name = 'dev_aws_data'

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
        table_input['PartitionKeys'] = []

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
        print(f"La tabla {new_table_name} ha sido creada correctamente.")
        
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