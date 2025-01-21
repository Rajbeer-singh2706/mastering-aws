import sys
from awsglue.transforms import *
from awsglue.utils import getResolvedOptions
from pyspark.context import SparkContext
from awsglue.context import GlueContext
from awsglue.job import Job
from awsglue.dynamicframe import DynamicFrameCollection
from awsglue.dynamicframe import DynamicFrame


# Script generated for node convert_string_to_date
def ConvertDateStringToDate(glueContext, dfc) -> DynamicFrameCollection:
    sparkDF = dfc.select(list(dfc.keys())[0]).toDF()
    sparkDF.createOrReplaceTempView("inputTable")

    df = spark.sql(
        "select TO_DATE(CAST(UNIX_TIMESTAMP(date, 'yyyyMMdd') AS TIMESTAMP)) as date, \
                           state , \
                           positiveIncrease ,  \
                           totalTestResultsIncrease \
                    from   inputTable"
    )

    dyf = DynamicFrame.fromDF(df, glueContext, "results")
    return DynamicFrameCollection({"CustomTransform0": dyf}, glueContext)


# Script generated for node PivotValue
def PivotValue(glueContext, dfc) -> DynamicFrameCollection:
    sparkDF = dfc.select(list(dfc.keys())[0]).toDF()
    sparkDF.createOrReplaceTempView("inputTable")

    df = spark.sql(
        "select * from inputTable \
                    pivot (avg(positivePercentage) as positivePercentage \
                    for state in ('NY' as positivePercentageNY, 'CA' as positivePercentageCA))"
    )

    dyf = DynamicFrame.fromDF(df, glueContext, "results")
    return DynamicFrameCollection({"CustomTransform0": dyf}, glueContext)


# Script generated for node drop_fields
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


# Script generated for node filter_and_calc_perc
def FilterAndCalculatePercentage(glueContext, dfc) -> DynamicFrameCollection:
    sparkDF = dfc.select(list(dfc.keys())[0]).toDF()
    sparkDF.createOrReplaceTempView("inputTable")

    df = spark.sql(
        "select  date , \
                            state , \
                            (positiveIncrease * 100 / totalTestResultsIncrease) as positivePercentage \
                    from inputTable \
                    where state in ('NY', 'CA')"
    )

    dyf = DynamicFrame.fromDF(df, glueContext, "results")
    return DynamicFrameCollection({"CustomTransform0": dyf}, glueContext)


args = getResolvedOptions(sys.argv, ["JOB_NAME"])
sc = SparkContext()
glueContext = GlueContext(sc)
spark = glueContext.spark_session
job = Job(glueContext)
job.init(args["JOB_NAME"], args)

# Script generated for node s3_source
s3_source_node1689762591317 = glueContext.create_dynamic_frame.from_catalog(
    database="examples_glueworkshop_db",
    table_name="json",
    transformation_ctx="s3_source_node1689762591317",
)

# Script generated for node drop_fields
drop_fields_node1689763590578 = DeleteFields(
    glueContext,
    DynamicFrameCollection(
        {"s3_source_node1689762591317": s3_source_node1689762591317}, glueContext
    ),
)

# Script generated for node select_df
select_df_node1689763965507 = SelectFromCollection.apply(
    dfc=drop_fields_node1689763590578,
    key=list(drop_fields_node1689763590578.keys())[0],
    transformation_ctx="select_df_node1689763965507",
)

# Script generated for node convert_string_to_date
convert_string_to_date_node1689764489817 = ConvertDateStringToDate(
    glueContext,
    DynamicFrameCollection(
        {"select_df_node1689763965507": select_df_node1689763965507}, glueContext
    ),
)

# Script generated for node select_df
select_df_node1689764656975 = SelectFromCollection.apply(
    dfc=convert_string_to_date_node1689764489817,
    key=list(convert_string_to_date_node1689764489817.keys())[0],
    transformation_ctx="select_df_node1689764656975",
)

# Script generated for node filter_and_calc_perc
filter_and_calc_perc_node1689764711797 = FilterAndCalculatePercentage(
    glueContext,
    DynamicFrameCollection(
        {"select_df_node1689764656975": select_df_node1689764656975}, glueContext
    ),
)

# Script generated for node select_df
select_df_node1689765040645 = SelectFromCollection.apply(
    dfc=filter_and_calc_perc_node1689764711797,
    key=list(filter_and_calc_perc_node1689764711797.keys())[0],
    transformation_ctx="select_df_node1689765040645",
)

# Script generated for node PivotValue
PivotValue_node1689765073201 = PivotValue(
    glueContext,
    DynamicFrameCollection(
        {"select_df_node1689765040645": select_df_node1689765040645}, glueContext
    ),
)

# Script generated for node select_df_final
select_df_final_node1689765285162 = SelectFromCollection.apply(
    dfc=PivotValue_node1689765073201,
    key=list(PivotValue_node1689765073201.keys())[0],
    transformation_ctx="select_df_final_node1689765285162",
)

# Script generated for node s3Sink
s3Sink_node1689764055015 = glueContext.write_dynamic_frame.from_options(
    frame=select_df_final_node1689765285162,
    connection_type="s3",
    format="json",
    connection_options={
        "path": "s3://glueworkshop-raj-14072023/output/lab6/temp1/",
        "partitionKeys": [],
    },
    transformation_ctx="s3Sink_node1689764055015",
)

job.commit()
