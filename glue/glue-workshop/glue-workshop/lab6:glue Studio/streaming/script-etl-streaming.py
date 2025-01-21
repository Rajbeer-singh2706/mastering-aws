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

# Script generated for node kinesis_source
dataframe_kinesis_source_node1689753956030 = glueContext.create_data_frame.from_catalog(
    database="examples",
    table_name="example2_table",
    additional_options={"startingPosition": "earliest", "inferSchema": "true"},
    transformation_ctx="dataframe_kinesis_source_node1689753956030",
)

# Script generated for node s3_source
s3_source_node1689755956020 = glueContext.create_dynamic_frame.from_options(
    format_options={"quoteChar": '"', "withHeader": True, "separator": ","},
    connection_type="s3",
    format="csv",
    connection_options={
        "paths": ["s3://glueworkshop-raj-14072023/input/lab6/country_lookup/"],
        "recurse": True,
    },
    transformation_ctx="s3_source_node1689755956020",
)


def processBatch(data_frame, batchId):
    if data_frame.count() > 0:
        kinesis_source_node1689753956030 = DynamicFrame.fromDF(
            data_frame, glueContext, "from_data_frame"
        )
        # Script generated for node joined_frame
        s3_source_node1689755956020DF = s3_source_node1689755956020.toDF()
        kinesis_source_node1689753956030DF = kinesis_source_node1689753956030.toDF()
        joined_frame_node1689756303485 = DynamicFrame.fromDF(
            s3_source_node1689755956020DF.join(
                kinesis_source_node1689753956030DF,
                (
                    s3_source_node1689755956020DF["CountryName"]
                    == kinesis_source_node1689753956030DF["country"]
                ),
                "left",
            ),
            glueContext,
            "joined_frame_node1689756303485",
        )

        # Script generated for node drop_frields_frame
        drop_frields_frame_node1689756456578 = DropFields.apply(
            frame=joined_frame_node1689756303485,
            paths=[
                "CountryName",
                "orderpriority",
                "orderdate",
                "region",
                "shipdate",
                "unitssold",
                "unitprice",
                "unitcost",
            ],
            transformation_ctx="drop_frields_frame_node1689756456578",
        )

        now = datetime.datetime.now()
        year = now.year
        month = now.month
        day = now.day
        hour = now.hour

        # Script generated for node s3sink
        s3sink_node1689756582397_path = (
            "s3://glueworkshop-raj-14072023/output/lab6/streamingoutput"
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
        s3sink_node1689756582397 = glueContext.write_dynamic_frame.from_options(
            frame=drop_frields_frame_node1689756456578,
            connection_type="s3",
            format="csv",
            connection_options={
                "path": s3sink_node1689756582397_path,
                "partitionKeys": [],
            },
            transformation_ctx="s3sink_node1689756582397",
        )


glueContext.forEachBatch(
    frame=dataframe_kinesis_source_node1689753956030,
    batch_function=processBatch,
    options={
        "windowSize": "100 seconds",
        "checkpointLocation": args["TempDir"] + "/" + args["JOB_NAME"] + "/checkpoint/",
    },
)
job.commit()
