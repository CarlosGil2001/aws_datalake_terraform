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
DropNullFields= drop_nulls(glueContext, frame=DropFields, nullStringSet={"", "null"}, nullIntegerSet={-1}, transformation_ctx="DropNullFields")

# Script generated Rename Field
RenameField_work_year = RenameField.apply(frame=DropNullFields, old_name="work_year", new_name="year", transformation_ctx="RenameField_work_year")
RenameField_work_year = RenameField.apply(frame=DropNullFields, old_name="work_year", new_name="year", transformation_ctx="RenameField_work_year")
RenameField_work_year = RenameField.apply(frame=DropNullFields, old_name="work_year", new_name="year", transformation_ctx="RenameField_work_year")
RenameField_work_year = RenameField.apply(frame=DropNullFields, old_name="work_year", new_name="year", transformation_ctx="RenameField_work_year")
RenameField_work_year = RenameField.apply(frame=DropNullFields, old_name="work_year", new_name="year", transformation_ctx="RenameField_work_year")
RenameField_work_year = RenameField.apply(frame=DropNullFields, old_name="work_year", new_name="year", transformation_ctx="RenameField_work_year")

# Script generated for node Amazon S3
AmazonS3_output = glueContext.write_dynamic_frame.from_options(frame=RenameField_node1712721915302, connection_type="s3", format="glueparquet", connection_options={"path": "s3://bk-11651651-silver/orders/", "partitionKeys": []}, format_options={"compression": "snappy"}, transformation_ctx="AmazonS3_output")

job.commit()