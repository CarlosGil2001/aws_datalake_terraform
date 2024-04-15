import sys
from awsglue.transforms import *
from awsglue.utils import getResolvedOptions
from pyspark.context import SparkContext
from awsglue.context import GlueContext
from awsglue.job import Job
from awsglue import DynamicFrame

args = getResolvedOptions(sys.argv, ['JOB_NAME'])
sc = SparkContext()
glueContext = GlueContext(sc)
spark = glueContext.spark_session
job = Job(glueContext)
job.init(args['JOB_NAME'], args)

# Script generated for node AWS Glue Data Catalog
AWSGlueDataCatalog = glueContext.create_dynamic_frame.from_catalog(database="dev_aws_data", table_name="ds_salaries_sl", transformation_ctx="AWSGlueDataCatalog")

# Convert Glue DynamicFrame to PySpark DataFrame
df_spark = AWSGlueDataCatalog.toDF()
df_remove_col = df_spark.drop('partition_0')

# Convert PySpark DataFrame to Glue DynamicFrame
dynamicDF = DynamicFrame.fromDF(df_remove_col, glueContext, "dynamicDF")

# Write in the bucket
Write_AmazonS3 = glueContext.write_dynamic_frame.from_options(frame=dynamicDF, connection_type="s3", format="glueparquet", connection_options={"path": "s3://bk-goldzone-project1-dev-useast1/jobs/", "partitionKeys": []}, format_options={"compression": "snappy"}, transformation_ctx="Write_AmazonS3")
job.commit()