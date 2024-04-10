import sys
from awsglue.transforms import *
from awsglue.utils import getResolvedOptions
from pyspark.context import SparkContext
from pyspark.sql.functions import col, when
from awsglue.context import GlueContext
from awsglue.job import Job
from awsglue.gluetypes import *
from awsglue import DynamicFrame


def transform_experience_level(frame):
    def _transform_experience_level(experience_level):
        if experience_level == "SE":
            return "Senior Level"
        elif experience_level == "MI":
            return "Mid Level"
        elif experience_level == "EN":
            return "Entry Level"
        elif experience_level == "EX":
            return "Executive Level"
        else:
            return experience_level

    return frame.map(_transform_experience_level, transformation_ctx="transform_experience_level")

args = getResolvedOptions(sys.argv, ['JOB_NAME'])
sc = SparkContext()
glueContext = GlueContext(sc)
spark = glueContext.spark_session
job = Job(glueContext)
job.init(args['JOB_NAME'], args)

# Script generated AWS Glue Data Catalog
AWSGlueDataCatalog = glueContext.create_dynamic_frame.from_catalog(database="db_aws_data", table_name="testbk_1651516_bronze", transformation_ctx="AWSGlueDataCatalog")
df_spark = AWSGlueDataCatalog.toDf()
columns_to_drop = ['remote_ratio', 'partition_0']
df_spark1 = df_spark.drop(*columns_to_drop)
df_spark2 = df_spark1.withColumn("experience_level",when(col("experience_level")=="SE", "Senior Level").when(col(experience_level)=="MI", "Mid Level").when(col(experience_level)=="EN", "Entry Level").otherwise("Executive Leve").alias(""))
dynamicDF = DynamicFrame.fromDF(df_spark2, glueContext, "dynamicDF")

AmazonS3_output = glueContext.write_dynamic_frame.from_options(frame=dynamicDF, connection_type="s3", format="glueparquet", connection_options={"path": "s3://bk-11651651-silver/orders/", "partitionKeys": []}, format_options={"compression": "snappy"}, transformation_ctx="AmazonS3_output")

job.commit()
