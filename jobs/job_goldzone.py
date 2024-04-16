import sys
from awsglue.transforms import *
from awsglue.utils import getResolvedOptions
from pyspark.context import SparkContext
from awsglue.context import GlueContext
from awsglue.job import Job
from awsglue import DynamicFrame
from pyspark.sql.functions import col, when

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
df_cast_salary = df_remove_col.withColumn('Salary_In_USD', col('Salary_In_USD').alias('Salary_In_USD').cast('decimal(23,2)'))
df_range_salary = df_cast_salary.withColumn('salary_classification', when(col('Salary_In_USD')<=100000, 'Low').when((col('Salary_In_USD')>100000) & (col('Salary_In_USD')<=250000), 'Medium').otherwise('High'))
# Convert PySpark DataFrame to Glue DynamicFrame
dynamicDF = DynamicFrame.fromDF(df_range_salary, glueContext, "dynamicDF")

# Write in the bucket
Write_AmazonS3 = glueContext.write_dynamic_frame.from_options(frame=dynamicDF, connection_type="s3", format="glueparquet", connection_options={"path": "s3://bk-goldzone-project1-dev-useast1/jobs/", "partitionKeys": []}, format_options={"compression": "snappy"}, transformation_ctx="Write_AmazonS3")
job.commit()