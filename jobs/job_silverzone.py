import sys
from awsglue.transforms import *
from awsglue.utils import getResolvedOptions
from pyspark.context import SparkContext
from pyspark.sql.functions import col, when
from awsglue.context import GlueContext
from awsglue.job import Job
from awsglue.gluetypes import *
from awsglue import DynamicFrame

args = getResolvedOptions(sys.argv, ['JOB_NAME'])
sc = SparkContext()
glueContext = GlueContext(sc)
spark = glueContext.spark_session
job = Job(glueContext)
job.init(args['JOB_NAME'], args)

# Read table from AWS Catalog
AWSGlueDataCatalog = glueContext.create_dynamic_frame.from_catalog(database="dev_aws_data", table_name="ds_salaries_br", transformation_ctx="AWSGlueDataCatalog")

# Convert Glue DynamicFrame to PySpark DataFrame
df_spark = AWSGlueDataCatalog.toDF()
df_remove_col = df_spark.drop('remote_ratio').drop('partition_0')
df_cond_exp = df_remove_col.withColumn("experience_level",when(col("experience_level")=="SE", "Senior Level").when(col("experience_level")=="MI", "Mid Level").when(col("experience_level")=="EN", "Entry Level").otherwise("Executive Leve"))
df_cond_emp = df_cond_exp.withColumn("employment_type",when(col("employment_type")=="FT", "Full Time").when(col("employment_type")=="CT", "Contract basis").when(col("employment_type")=="FL", "Freelancer").otherwise("Part Time"))
df_cond_comp = df_cond_emp.withColumn("company_size",when(col("company_size")=="L", "Large").when(col("company_size")=="S", "Small").otherwise("Medium"))
df_rename_col = df_cond_comp.withColumnRenamed('work_year', 'Year').withColumnRenamed('experience_level', 'Experience_Level').withColumnRenamed('employment_type', 'Job_Type').withColumnRenamed('job_title', 'Job_Description').withColumnRenamed('salary', 'Salary').withColumnRenamed('salary_currency', 'Salary_Currency').withColumnRenamed('salary_in_usd', 'Salary_In_USD').withColumnRenamed('employee_residence', 'Employee_Location').withColumnRenamed('company_location', 'Company_Location').withColumnRenamed('company_size', 'Company_Size')

# Convert PySpark DataFrame to Glue DynamicFrame
dynamicDF = DynamicFrame.fromDF(df_rename_col, glueContext, "dynamicDF")

# Write in the bucket
AmazonS3_output = glueContext.write_dynamic_frame.from_options(frame=dynamicDF, connection_type="s3", format="glueparquet", connection_options={"path": "s3://bk-silverzone-project1-dev-useast1/jobs/", "partitionKeys": []}, format_options={"compression": "snappy"}, transformation_ctx="AmazonS3_output")
job.commit()
