import sys
from awsglue.transforms import *
from awsglue.utils import getResolvedOptions
from pyspark.context import SparkContext
from awsglue.context import GlueContext
from awsglue.job import Job

from pyspark.sql import DataFrame, Row
import datetime
from awsglue import DynamicFrame
from awsglue.dynamicframe import DynamicFrame

args = getResolvedOptions(sys.argv, ["JOB_NAME"])
sc = SparkContext()
glueContext = GlueContext(sc)
spark = glueContext.spark_session
job = Job(glueContext)
job.init(args["JOB_NAME"], args)

# Script generated for node Amazon Kinesis
dataframe_AmazonKinesis_node1689854712357 = glueContext.create_data_frame.from_catalog(
    database="examples_glueimmersion_db",
    table_name="lab5_kinesis",
    additional_options={"startingPosition": "latest", "inferSchema": "false"},
    transformation_ctx="dataframe_AmazonKinesis_node1689854712357",
)

# Script generated for node country_lookup
country_lookup_node1689854970712 = glueContext.create_dynamic_frame.from_options(
    format_options={"quoteChar": '"', "withHeader": True, "separator": ","},
    connection_type="s3",
    format="csv",
    connection_options={
        "paths": [
            "s3://glueworkshop-350261890139-ap-south-1/input/lab6/country_lookup/country_lookup.csv"
        ],
        "recurse": True,
    },
    transformation_ctx="country_lookup_node1689854970712",
)


def processBatch(data_frame, batchId):
    if data_frame.count() > 0:
        AmazonKinesis_node1689854712357 = DynamicFrame.fromDF(
            data_frame, glueContext, "from_data_frame"
        )
        # Script generated for node Join
        AmazonKinesis_node1689854712357DF = AmazonKinesis_node1689854712357.toDF()
        country_lookup_node1689854970712DF = country_lookup_node1689854970712.toDF()
        Join_node1689856129758 = DynamicFrame.fromDF(
            AmazonKinesis_node1689854712357DF.join(
                country_lookup_node1689854970712DF,
                (
                    AmazonKinesis_node1689854712357DF["country"]
                    == country_lookup_node1689854970712DF["CountryName"]
                ),
                "left",
            ),
            glueContext,
            "Join_node1689856129758",
        )

        # Script generated for node Drop Fields
        DropFields_node1689856260962 = DropFields.apply(
            frame=Join_node1689856129758,
            paths=[
                "orderpriority",
                "orderdate",
                "shipdate",
                "region",
                "unitssold",
                "unitprice",
                "CountryName",
            ],
            transformation_ctx="DropFields_node1689856260962",
        )

        now = datetime.datetime.now()
        year = now.year
        month = now.month
        day = now.day
        hour = now.hour

        # Script generated for node Amazon S3
        AmazonS3_node1689856276629_path = (
            "s3://glueworkshop-350261890139-ap-south-1/output/lab5/streamingoutput"
            + "/ingest_year="
            + "{:0>4}".format(str(year))
            + "/ingest_month="
            + "{:0>2}".format(str(month))
            + "/ingest_day="
            + "{:0>2}".format(str(day))
            + "/ingest_hour="
            + "{:0>2}".format(str(hour))
            + "/"
        )
        AmazonS3_node1689856276629 = glueContext.write_dynamic_frame.from_options(
            frame=DropFields_node1689856260962,
            connection_type="s3",
            format="csv",
            connection_options={
                "path": AmazonS3_node1689856276629_path,
                "partitionKeys": [],
            },
            transformation_ctx="AmazonS3_node1689856276629",
        )


glueContext.forEachBatch(
    frame=dataframe_AmazonKinesis_node1689854712357,
    batch_function=processBatch,
    options={
        "windowSize": "100 seconds",
        "checkpointLocation": args["TempDir"] + "/" + args["JOB_NAME"] + "/checkpoint/",
    },
)
job.commit()
