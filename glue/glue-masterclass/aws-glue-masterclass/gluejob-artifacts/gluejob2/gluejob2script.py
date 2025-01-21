from pyspark.context import SparkContext
from awsglue.context import GlueContext
from awsglue.utils import getResolvedOptions
import sys
import datetime


print('Process Started')
print('Reading the argument')

# Reading the parameter
args = getResolvedOptions (sys.argv,['s3_source_bucket','s3_destination_bucket'])
source_bucket = args['s3_source_bucket']
target_bucket = args['s3_destination_bucket']
print(source_bucket)


# Create the Spark Context
glue_context = GlueContext(SparkContext())
spark = glue_context.spark_session
extracted = datetime.datetime.today().strftime('%Y-%m-%d')

# Read and Write data
df = spark.read.format("csv").option("header",True).load("s3a://{0}/*".format(source_bucket))
df = df.filter( (df.Country == "Algeria") & (df.City == "Algiers") & (df.Year > 2016) )
df.write.mode('overwrite').partitionBy("Year").parquet("s3a://{0}/extracted_date={1}/".format(target_bucket, extracted))


