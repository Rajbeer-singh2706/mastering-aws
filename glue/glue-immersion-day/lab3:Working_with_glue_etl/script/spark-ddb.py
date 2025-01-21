import os, sys, boto3
from pprint import pprint
from awsglue.transforms import *
from awsglue.utils import getResolvedOptions
from awsglue.context import GlueContext
from awsglue.job import Job
from awsglue.dynamicframe import DynamicFrame

from pyspark.sql.functions import udf, col
from pyspark.sql.types import IntegerType, StringType
from pyspark.sql import SQLContext
from pyspark.context import SparkContext

from datetime import datetime
from pycountry_convert import (
    convert_country_alpha2_to_country_name,
    convert_country_alpha2_to_continent,
    convert_country_name_to_country_alpha2,
    convert_country_alpha3_to_country_alpha2,
)


def get_country_code2(country_name):
    country_code2 = 'US'
    try:
        country_code2 = convert_country_name_to_country_alpha2(country_name)
    except KeyError:
        country_code2 = ''
    return country_code2


udf_get_country_code2 = udf(lambda z: get_country_code2(z), StringType())

## @params: [JOB_NAME]
args = getResolvedOptions(sys.argv, ['JOB_NAME', 's3_bucket_name', 'ddb_table_name', 'region_name'])

s3_bucket_name = args['s3_bucket_name']
ddb_table_name = args['ddb_table_name']
region_name = args['region_name']

glueContext = GlueContext(SparkContext.getOrCreate())
job = Job(glueContext)
job.init(args['JOB_NAME'], args)
spark = glueContext.spark_session

# Create the dynamodb with appropriate read and write capacity
# Get service resource
dynamodb = boto3.resource('dynamodb', region_name=region_name)

table_status = dynamodb.create_table(
    TableName=ddb_table_name,
    KeySchema=[{'AttributeName': 'uuid','KeyType': 'HASH'}],
    AttributeDefinitions=[{'AttributeName': 'uuid','AttributeType': 'N'}],
    ProvisionedThroughput={'ReadCapacityUnits': 500,'WriteCapacityUnits': 5000}
    )
# Wait until the table exists.
table_status.meta.client.get_waiter('table_exists').wait(TableName=ddb_table_name)
pprint(table_status)

s3_bucket = os.path.join('s3://', s3_bucket_name)
df = spark.read.load(os.path.join(s3_bucket,"input/lab2/sample.csv"),
                     format="csv",
                     sep=",",
                     inferSchema="true",
                     header="true")
new_df = df.withColumn('country_code_2', udf_get_country_code2(col("Country")))
new_df_dyf=DynamicFrame.fromDF(new_df, glueContext, "new_df_dyf")

print("Start writing to DBB : {}".format(datetime.now().strftime("%Y-%m-%d %H:%M:%S")))
glueContext.write_dynamic_frame_from_options(
    frame=new_df_dyf,
    connection_type="dynamodb",
    connection_options={
        "dynamodb.output.tableName": ddb_table_name,
        "dynamodb.throughput.write.percent": "1.0"
    }
)
print("Finished writing to DBB : {}".format(datetime.now().strftime("%Y-%m-%d %H:%M:%S")))
job.commit()