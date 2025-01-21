import sys
from awsglue.transforms import *
from awsglue.utils import getResolvedOptions
from pyspark.context import SparkContext
from awsglue.context import GlueContext
from awsglue.job import Job
from awsglueml.transforms import EntityDetector
from pyspark.sql.types import StringType
from awsglue.dynamicframe import DynamicFrame
from pyspark.sql.functions import *

args = getResolvedOptions(sys.argv, ["JOB_NAME"])
sc = SparkContext()
glueContext = GlueContext(sc)
spark = glueContext.spark_session
job = Job(glueContext)
job.init(args["JOB_NAME"], args)

# Script generated for node pii-source-data
piisourcedata_node1689846304863 = glueContext.create_dynamic_frame.from_options(
    format_options={"quoteChar": '"', "withHeader": True, "separator": ","},
    connection_type="s3",
    format="csv",
    connection_options={
        "paths": ["s3://glueworkshop-350261890139-ap-south-1/input/lab5/pii/"],
        "recurse": True,
    },
    transformation_ctx="piisourcedata_node1689846304863",
)

# Script generated for node Detect Sensitive Data
entity_detector = EntityDetector()
detected_df = entity_detector.detect(
    piisourcedata_node1689846304863,
    [
        "CREDIT_CARD",
        "EMAIL",
        "USA_SSN",
        "Valid U.S. Phone Number (not starting with 0 or 1)",
    ],
    "DetectedEntities",
)


def replace_cell(original_cell_value, sorted_reverse_start_end_tuples):
    if sorted_reverse_start_end_tuples:
        for entity in sorted_reverse_start_end_tuples:
            to_mask_value = original_cell_value[entity[0] : entity[1]]
            original_cell_value = original_cell_value.replace(to_mask_value, "XXXXXXX")
    return original_cell_value


def row_pii(column_name, original_cell_value, detected_entities):
    if column_name in detected_entities.keys():
        entities = detected_entities[column_name]
        start_end_tuples = map(
            lambda entity: (entity["start"], entity["end"]), entities
        )
        sorted_reverse_start_end_tuples = sorted(
            start_end_tuples, key=lambda start_end: start_end[1], reverse=True
        )
        return replace_cell(original_cell_value, sorted_reverse_start_end_tuples)
    return original_cell_value


row_pii_udf = udf(row_pii, StringType())


def recur(df, remaining_keys):
    if len(remaining_keys) == 0:
        return df
    else:
        head = remaining_keys[0]
        tail = remaining_keys[1:]
        modified_df = df.withColumn(
            head, row_pii_udf(lit(head), head, "DetectedEntities")
        )
        return recur(modified_df, tail)


keys = piisourcedata_node1689846304863.toDF().columns
updated_masked_df = recur(detected_df.toDF(), keys)
updated_masked_df = updated_masked_df.drop("DetectedEntities")

DetectSensitiveData_node1689846471783 = DynamicFrame.fromDF(
    updated_masked_df, glueContext, "updated_masked_df"
)

# Script generated for node lab5_redacted
lab5_redacted_node1689847032475 = glueContext.getSink(
    path="s3://glueworkshop-350261890139-ap-south-1/output/lab5/pii/",
    connection_type="s3",
    updateBehavior="UPDATE_IN_DATABASE",
    partitionKeys=[],
    enableUpdateCatalog=True,
    transformation_ctx="lab5_redacted_node1689847032475",
)
lab5_redacted_node1689847032475.setCatalogInfo(
    catalogDatabase="examples_glueimmersion_db", catalogTableName="lab5_redacted"
)
lab5_redacted_node1689847032475.setFormat("json")
lab5_redacted_node1689847032475.writeFrame(DetectSensitiveData_node1689846471783)
job.commit()
