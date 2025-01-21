import sys
from awsglue.transforms import *
from awsglue.utils import getResolvedOptions
from pyspark.context import SparkContext
from awsglue.context import GlueContext
from awsglue.job import Job
from awsglue.dynamicframe import DynamicFrameCollection
from awsglue.dynamicframe import DynamicFrame


# Script generated for node Library Transformation
def AggregateCaseCount(glueContext, dfc) -> DynamicFrameCollection:
    from pyspark.sql.functions import udf, col
    from pyspark.sql.types import IntegerType, StringType
    from pyspark.sql import functions as f
    from pycountry_convert import (
        convert_country_alpha2_to_country_name,
        convert_country_alpha2_to_continent,
        convert_country_name_to_country_alpha2,
        convert_country_alpha3_to_country_alpha2,
    )

    def get_country_code2(country_name):
        country_code2 = "US"
        try:
            country_code2 = convert_country_name_to_country_alpha2(country_name)
        except KeyError:
            country_code2 = ""
        return country_code2

    udf_get_country_code2 = udf(lambda z: get_country_code2(z), StringType())

    df = dfc.select(list(dfc.keys())[0]).toDF()
    df0 = df.withColumn("country_code_2", udf_get_country_code2(f.col("Country")))
    dyf0 = DynamicFrame.fromDF(df0, glueContext, "result0")

    return DynamicFrameCollection({"CustomTransform0": dyf0}, glueContext)


args = getResolvedOptions(sys.argv, ["JOB_NAME"])
sc = SparkContext()
glueContext = GlueContext(sc)
spark = glueContext.spark_session
job = Job(glueContext)
job.init(args["JOB_NAME"], args)

# Script generated for node Source Data
SourceData_node1689853855081 = glueContext.create_dynamic_frame.from_options(
    format_options={"quoteChar": '"', "withHeader": True, "separator": ","},
    connection_type="s3",
    format="csv",
    connection_options={
        "paths": ["s3://glueworkshop-350261890139-ap-south-1/input/lab2/sample.csv"],
        "recurse": True,
    },
    transformation_ctx="SourceData_node1689853855081",
)

# Script generated for node Library Transformation
LibraryTransformation_node1689853928785 = AggregateCaseCount(
    glueContext,
    DynamicFrameCollection(
        {"SourceData_node1689853855081": SourceData_node1689853855081}, glueContext
    ),
)

job.commit()
