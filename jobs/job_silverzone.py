import sys
from awsglue.transforms import *
from awsglue.utils import getResolvedOptions
from pyspark.context import SparkContext
from awsglue.context import GlueContext
from awsglue.job import Job

args = getResolvedOptions(sys.argv, ['JOB_NAME'])
sc = SparkContext()
glueContext = GlueContext(sc)
spark = glueContext.spark_session
job = Job(glueContext)
job.init(args['JOB_NAME'], args)

# Script generated for node AWS Glue Data Catalog
AWSGlueDataCatalog = glueContext.create_dynamic_frame.from_catalog(database="db_aws_data", table_name="testbk_1651516_bronze", transformation_ctx="AWSGlueDataCatalog")

# Script generated for node Drop Fields
DropFields = DropFields.apply(frame=AWSGlueDataCatalog, paths=["orden_electronica", "orden_digitalizada", "documento_estado_ocam", "fecha_formalizacion", "fecha_ultimo_estado", "orden_electronica_generada", "partition_0"], transformation_ctx="DropFields")

# Script generated for node Amazon S3
Write_AmazonS3 = glueContext.write_dynamic_frame.from_options(frame=DropFields, connection_type="s3", format="glueparquet", connection_options={"path": "s3://bk-silverzone-project1-dev-useast2/orders/", "partitionKeys": []}, format_options={"compression": "snappy"}, transformation_ctx="Write_AmazonS3")

job.commit()