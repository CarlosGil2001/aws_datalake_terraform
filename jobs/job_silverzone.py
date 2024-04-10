import sys
from awsglue.transforms import *
from awsglue.utils import getResolvedOptions
from pyspark.context import SparkContext
from awsglue.context import GlueContext
from awsglue.job import Job
from awsglue.gluetypes import *
from awsglue import DynamicFrame

def _find_null_fields(ctx, schema, path, output, nullStringSet, nullIntegerSet, frame):
    if isinstance(schema, StructType):
        for field in schema:
            new_path = path + "." if path != "" else path
            output = _find_null_fields(ctx, field.dataType, new_path + field.name, output, nullStringSet, nullIntegerSet, frame)
    elif isinstance(schema, ArrayType):
        if isinstance(schema.elementType, StructType):
            output = _find_null_fields(ctx, schema.elementType, path, output, nullStringSet, nullIntegerSet, frame)
    elif isinstance(schema, NullType):
        output.append(path)
    else:
        x, distinct_set = frame.toDF(), set()
        for i in x.select(path).distinct().collect():
            distinct_ = i[path.split('.')[-1]]
            if isinstance(distinct_, list):
                distinct_set |= set([item.strip() if isinstance(item, str) else item for item in distinct_])
            elif isinstance(distinct_, str) :
                distinct_set.add(distinct_.strip())
            else:
                distinct_set.add(distinct_)
        if isinstance(schema, StringType):
            if distinct_set.issubset(nullStringSet):
                output.append(path)
        elif isinstance(schema, IntegerType) or isinstance(schema, LongType) or isinstance(schema, DoubleType):
            if distinct_set.issubset(nullIntegerSet):
                output.append(path)
    return output

def drop_nulls(glueContext, frame, nullStringSet, nullIntegerSet, transformation_ctx) -> DynamicFrame:
    nullColumns = _find_null_fields(frame.glue_ctx, frame.schema(), "", [], nullStringSet, nullIntegerSet, frame)
    return DropFields.apply(frame=frame, paths=nullColumns, transformation_ctx=transformation_ctx)

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

# Script generated Drop Fields
DropFields = DropFields.apply(frame=AWSGlueDataCatalog, paths=["partition_0", "remote_ratio"], transformation_ctx="DropFields")

# Script generated for node Drop Null Fields
DropNullFields = drop_nulls(glueContext, frame=DropFields, nullStringSet={"", "null"}, nullIntegerSet={-1}, transformation_ctx="DropNullFields")

# Script generated Transform Experience Level
TransformExperienceLevel = transform_experience_level(DropNullFields)

# Script generated Rename Field
RenameField_work_year = RenameField.apply(frame=TransformExperienceLevel, old_name="work_year", new_name="year", transformation_ctx="RenameField_work_year")
RenameField_experience_level = RenameField.apply(frame=RenameField_work_year, old_name="experience_level", new_name="Experience Level", transformation_ctx="RenameField_experience_level")
RenameField_employment_type = RenameField.apply(frame=RenameField_experience_level, old_name="employment_type", new_name="Job Type", transformation_ctx="RenameField_employment_type")
RenameField_job_title = RenameField.apply(frame=RenameField_employment_type, old_name="job_title ", new_name="Job Description", transformation_ctx="RenameField_job_title")
RenameField_salary = RenameField.apply(frame=RenameField_job_title, old_name="salary", new_name="Salary", transformation_ctx="RenameField_salary")
RenameField_salary_currency = RenameField.apply(frame=RenameField_salary, old_name="salary_currency", new_name="Salary Currency", transformation_ctx="RenameField_salary_currency")
RenameField_salary_in_usd = RenameField.apply(frame=RenameField_salary_currency, old_name="salary_in_usd", new_name="Salary In USD", transformation_ctx="RenameField_salary_in_usd")
RenameField_employee_residence = RenameField.apply(frame=RenameField_salary_in_usd, old_name="employee_residence ", new_name="Employee Location", transformation_ctx="RenameField_employee_residence")
RenameField_company_location = RenameField.apply(frame=RenameField_employee_residence, old_name="company_location", new_name="Company Location", transformation_ctx="RenameField_company_location")
RenameField_company_size = RenameField.apply(frame=RenameField_company_location, old_name="company_size", new_name="Company Size", transformation_ctx="RenameField_company_size")

# Script generated for node Amazon S3
AmazonS3_output = glueContext.write_dynamic_frame.from_options(frame=RenameField_company_size, connection_type="s3", format="glueparquet", connection_options={"path": "s3://bk-11651651-silver/orders/", "partitionKeys": []}, format_options={"compression": "snappy"}, transformation_ctx="AmazonS3_output")

job.commit()
