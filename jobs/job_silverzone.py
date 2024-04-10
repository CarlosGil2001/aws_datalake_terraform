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

# Read table from AWS Catalog
AWSGlueDataCatalog = glueContext.create_dynamic_frame.from_catalog(database="db_aws_data", table_name="crw_bronzezone_bk_bronzezone_project1_dev_useast1", transformation_ctx="AWSGlueDataCatalog")
# Convert Glue DynamicFrame to PySpark DataFrame
df_spark = AWSGlueDataCatalog.toDF()
df_spark1 = df_jobs.drop('remote_ratio').drop('partition_0')
df_spark2 = df_spark1.withColumn("experience_level",when(col("experience_level")=="SE", "Senior Level").when(col("experience_level")=="MI", "Mid Level").when(col("experience_level")=="EN", "Entry Level").otherwise("Executive Leve"))
df_spark3 = df_spark2.withColumn("employment_type",when(col("employment_type")=="FT", "Full Time").when(col("employment_type")=="CT", "Contract basis").when(col("employment_type")=="FL", "Freelancer").otherwise("Part Time"))
df_spark4 = df_spark3.withColumn("company_size",when(col("company_size")=="L", "Large").when(col("company_size")=="S", "Small").otherwise("Medium"))
df_spark5 = df_spark4.withColumnRenamed('work_year', 'Year').withColumnRenamed('experience_level', 'Experience Level').withColumnRenamed('employment_type', 'Job Type').withColumnRenamed('job_title', 'Job Description').withColumnRenamed('salary', 'Salary').withColumnRenamed('salary_currency', 'Salary Currency').withColumnRenamed('salary_in_usd', 'Salary In USD').withColumnRenamed('employee_residence', 'Employee Location').withColumnRenamed('company_location', 'Company Location').withColumnRenamed('company_size', 'Company Size')
# Convert PySpark DataFrame to Glue DynamicFrame
dynamicDF = DynamicFrame.fromDF(df_spark5, glueContext, "dynamicDF")

AmazonS3_output = glueContext.write_dynamic_frame.from_options(frame=dynamicDF, connection_type="s3", format="glueparquet", connection_options={"path": "s3://bk-silverzone-project1-dev-useast1/sales/", "partitionKeys": []}, format_options={"compression": "snappy"}, transformation_ctx="AmazonS3_output")

job.commit()
