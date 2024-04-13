import boto3

def lambda_handler(event, context):
    glue = boto3.client('glue')
    old_table_name = 'bk_goldzone_project1_dev_useast1'
    new_table_name = 'ds_salaries_gd'
    database_name = 'dev_aws_data'

    try:
        # Verificar si la tabla 'ds_salaries_gd' ya existe
        response = glue.get_table(
            DatabaseName=database_name,
            Name=new_table_name
        )
        
        table_exists = True
    except glue.exceptions.EntityNotFoundException:
        # Si la tabla 'ds_salaries_gd' no existe, se crea una nueva basada en la tabla 'bk-goldzone-project1-dev-useast1'
        table_exists = False
        response = glue.get_table(
            DatabaseName=database_name,
            Name=old_table_name
        )
        
        table_input = response['Table']
        table_input['Name'] = new_table_name

        # Eliminar los parámetros no reconocidos
        del table_input['DatabaseName']
        del table_input['CreateTime']
        del table_input['UpdateTime']
        del table_input['CreatedBy']
        del table_input['IsRegisteredWithLakeFormation']
        del table_input['CatalogId']
        del table_input['VersionId']

        # Crear la nueva tabla 'ds_salaries_gd'
        glue.create_table(
            DatabaseName=database_name,
            TableInput=table_input
        )

    if table_exists:
        print("La tabla 'ds_salaries_gd' ya existe en el catálogo de Glue.")
    else:
        print("La tabla 'ds_salaries_gd' ha sido creada correctamente.")

    # Eliminar la tabla 'bk-goldzone-project1-dev-useast1' si existe
    try:
        glue.delete_table(
            DatabaseName=database_name,
            Name=old_table_name
        )
        print("La tabla 'bk-goldzone-project1-dev-useast1' ha sido eliminada correctamente.")
    except glue.exceptions.EntityNotFoundException:
        print("La tabla 'bk-goldzone-project1-dev-useast1' no existe en el catálogo de Glue.")

    # Finalmente, se devuelve un mensaje de éxito
    return {
        "statusCode": 200,
        "body": "Proceso completado exitosamente."
    }