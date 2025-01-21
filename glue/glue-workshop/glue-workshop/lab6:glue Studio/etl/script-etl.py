import sys
from awsglue.transforms import *
from awsglue.utils import getResolvedOptions
from pyspark.context import SparkContext
from awsglue.context import GlueContext
from awsglue.job import Job
from awsglue.dynamicframe import DynamicFrameCollection
from awsglue.dynamicframe import DynamicFrame


# Script generated for node Custom Transform
def DeleteFields(glueContext, dfc) -> DynamicFrameCollection:
    sparkDF = dfc.select(list(dfc.keys())[0]).toDF()
    sparkDF.createOrReplaceTempView("covidtesting")

    df = spark.sql(
        "select  date, \
                            state , \
                            positiveIncrease ,  \
                            totalTestResultsIncrease \
                    from covidtesting"
    )

    dyf = DynamicFrame.fromDF(df, glueContext, "results")
    return DynamicFrameCollection({"CustomTransform0": dyf}, glueContext)


args = getResolvedOptions(sys.argv, ["JOB_NAME"])
sc = SparkContext()
glueContext = GlueContext(sc)
spark = glueContext.spark_session
job = Job(glueContext)
job.init(args["JOB_NAME"], args)

# Script generated for node Amazon S3
AmazonS3_node1689751362281 = glueContext.create_dynamic_frame.from_catalog(
    database="covid19_gluedemocicdtest",
    table_name="us_states",
    transformation_ctx="AmazonS3_node1689751362281",
)

# Script generated for node Custom Transform
CustomTransform_node1689751529212 = DeleteFields(
    glueContext,
    DynamicFrameCollection(
        {"AmazonS3_node1689751362281": AmazonS3_node1689751362281}, glueContext
    ),
)

# Script generated for node Select From Collection
SelectFromCollection_node1689752427343 = SelectFromCollection.apply(
    dfc=CustomTransform_node1689751529212,
    key=list(CustomTransform_node1689751529212.keys())[0],
    transformation_ctx="SelectFromCollection_node1689752427343",
)

# Script generated for node Amazon S3
AmazonS3_node1689752464341 = glueContext.write_dynamic_frame.from_options(
    frame=SelectFromCollection_node1689752427343,
    connection_type="s3",
    format="json",
    connection_options={
        "path": "s3://glueworkshop-raj-14072023/output/lab6/json/temp1/",
        "partitionKeys": [],
    },
    transformation_ctx="AmazonS3_node1689752464341",
)

job.commit()
