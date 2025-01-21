import sys
from awsglue.transforms import *
from awsglue.utils import getResolvedOptions
from pyspark.context import SparkContext
from awsglue.context import GlueContext
from awsglue.job import Job
from awsglue.dynamicframe import DynamicFrame
import re
from pyspark.sql import functions as SqlFuncs


def sparkAggregate(
    glueContext, parentFrame, groups, aggs, transformation_ctx
) -> DynamicFrame:
    aggsFuncs = []
    for column, func in aggs:
        aggsFuncs.append(getattr(SqlFuncs, func)(column))
    result = (
        parentFrame.toDF().groupBy(*groups).agg(*aggsFuncs)
        if len(groups) > 0
        else parentFrame.toDF().agg(*aggsFuncs)
    )
    return DynamicFrame.fromDF(result, glueContext, transformation_ctx)


args = getResolvedOptions(sys.argv, ["JOB_NAME"])
sc = SparkContext()
glueContext = GlueContext(sc)
spark = glueContext.spark_session
job = Job(glueContext)
job.init(args["JOB_NAME"], args)

# Script generated for node COVID data
COVIDdata_node1689839488607 = glueContext.create_dynamic_frame.from_catalog(
    database="examples_glueimmersion_db",
    table_name="json",
    transformation_ctx="COVIDdata_node1689839488607",
)

# Script generated for node state_name
state_name_node1689840068445 = glueContext.create_dynamic_frame.from_options(
    format_options={"quoteChar": '"', "withHeader": True, "separator": ","},
    connection_type="s3",
    format="csv",
    connection_options={
        "paths": ["s3://glueworkshop-350261890139-ap-south-1/input/lab5/state/"],
        "recurse": True,
    },
    transformation_ctx="state_name_node1689840068445",
)

# Script generated for node Drop Fields
DropFields_node1689839646484 = DropFields.apply(
    frame=COVIDdata_node1689839488607,
    paths=[
        "positive",
        "hospitalized",
        "death",
        "total",
        "hash",
        "datechecked",
        "totaltestresults",
        "fips",
        "negativeincrease",
        "positiveincrease",
        "totaltestresultsincrease",
        "negative",
        "pending",
    ],
    transformation_ctx="DropFields_node1689839646484",
)

# Script generated for node Filter
Filter_node1689839748292 = Filter.apply(
    frame=DropFields_node1689839646484,
    f=lambda row: (bool(re.match("NY|CA", row["state"]))),
    transformation_ctx="Filter_node1689839748292",
)

# Script generated for node Change Schema
ChangeSchema_node1689839873929 = ApplyMapping.apply(
    frame=Filter_node1689839748292,
    mappings=[
        ("date", "string", "date", "string"),
        ("state", "string", "state", "string"),
        ("deathincrease", "double", "deathincrease", "int"),
        ("hospitalizedincrease", "double", "hospitalizedincrease", "int"),
    ],
    transformation_ctx="ChangeSchema_node1689839873929",
)

# Script generated for node Join
ChangeSchema_node1689839873929DF = ChangeSchema_node1689839873929.toDF()
state_name_node1689840068445DF = state_name_node1689840068445.toDF()
Join_node1689840221412 = DynamicFrame.fromDF(
    ChangeSchema_node1689839873929DF.join(
        state_name_node1689840068445DF,
        (
            ChangeSchema_node1689839873929DF["state"]
            == state_name_node1689840068445DF["Code"]
        ),
        "left",
    ),
    glueContext,
    "Join_node1689840221412",
)

# Script generated for node Aggregate
Aggregate_node1689840598027 = sparkAggregate(
    glueContext,
    parentFrame=Join_node1689840221412,
    groups=["state"],
    aggs=[["deathincrease", "sum"], ["hospitalizedincrease", "sum"]],
    transformation_ctx="Aggregate_node1689840598027",
)

# Script generated for node Amazon S3
AmazonS3_node1689840829808 = glueContext.write_dynamic_frame.from_options(
    frame=Aggregate_node1689840598027,
    connection_type="s3",
    format="json",
    connection_options={
        "path": "s3://glueworkshop-350261890139-ap-south-1/output/",
        "partitionKeys": [],
    },
    transformation_ctx="AmazonS3_node1689840829808",
)

job.commit()
