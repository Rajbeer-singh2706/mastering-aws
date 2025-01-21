import sys
from awsglue.transforms import *
from awsglue.utils import getResolvedOptions
from pyspark.context import SparkContext
from awsglue.context import GlueContext
from awsglue.job import Job
from awsglue.dynamicframe import DynamicFrame

args = getResolvedOptions(sys.argv, ["JOB_NAME","TargetDir","TempDir"])
sc = SparkContext()
glueContext = GlueContext(sc)
spark = glueContext.spark_session
job = Job(glueContext)
job.init(args["JOB_NAME"], args)
tgt_path = args["TargetDir"]

# Script generated for node PostgreSQL table
SQLtable_node1 = glueContext.create_dynamic_frame.from_catalog(
    database="glueworkshop-cloudformation",
    table_name="lab5_rds_glueworkshop_orders",
    transformation_ctx="SQLtable_node1",
)

if SQLtable_node1.count() >0:
    # Script generated for node S3 bucket
    postdf=SQLtable_node1.toDF()
    postdf=postdf.coalesce(1)
    print("Processed Records in this Batch- ",postdf.count())
    print("ID of records processed in this Batch- ")
    postdf.agg({'orderid':'max'}).show()
    postdf.agg({'orderid':'min'}).show() 
    postdyf=DynamicFrame.fromDF(postdf, glueContext, "postdyf")
    S3bucket_node3 = glueContext.getSink(
        path=tgt_path,
        connection_type="s3",
        updateBehavior="UPDATE_IN_DATABASE",
        partitionKeys=[],
        enableUpdateCatalog=True,
        transformation_ctx="S3bucket_node3",
    )
    S3bucket_node3.setCatalogInfo(
        catalogDatabase="glueworkshop-cloudformation", catalogTableName="orders_target"
    )
    S3bucket_node3.setFormat("json")
    S3bucket_node3.writeFrame(postdyf)
else:
    print("Processed Records in this Batch- 0")
job.commit()
