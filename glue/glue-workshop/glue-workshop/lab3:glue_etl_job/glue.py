import sys
from awsglue.transforms import *
from awsglue.utils import getResolvedOptions
from awsglue.context import GlueContext
from awsglue.job import Job

from pyspark.context import SparkContext
from awsglue.dynamicframe import DynamicFrame

from pyspark.sql.functions import udf,col
from pyspark.sql.types import IntegerType, StringType

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
args = getResolvedOptions(sys.argv, ['JOB_NAME'], 's3_bucket')
s3_bucket = args['s3_bucket']
job_time_string = datetime.now().strftime("%Y%m%d%H%M%S")

sc = SparkContext()
glueContext = GlueContext(sc)
spark = glueContext.spark_session
job = Job(glueContext)
job.init(args['JOB_NAME'], args)


glueContext = GlueContext(SparkContext.getOrCreate())

dynaFrame = glueContext.create_dynamic_frame.from_catalog(database="glueworkshop-db", table_name="csv")
new_df = dynaFrame.toDF()

new_df = new_df.withColumn('country_code_2', udf_get_country_code2(col("Country")))
new_df.write.csv(s3_bucket + "/output/lab3/" + job_time_string + "/")


job.commit()