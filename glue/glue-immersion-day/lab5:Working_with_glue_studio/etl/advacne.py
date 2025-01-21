import sys
from awsglue.transforms import *
from awsglue.utils import getResolvedOptions
from pyspark.context import SparkContext
from awsglue.context import GlueContext
from awsglue.job import Job
from awsglue.dynamicframe import DynamicFrameCollection
from awsglue.dynamicframe import DynamicFrame
from awsglue import DynamicFrame


# Script generated for node Aggregate Case Count
def AggregateCaseCount(glueContext, dfc) -> DynamicFrameCollection:
    df = dfc.select(list(dfc.keys())[0]).toDF()
    from pyspark.sql import functions as f

    df0 = df.groupBy("combinedname").agg(
        {"positiveincrease": "sum", "totaltestresultsincrease": "sum"}
    )
    dyf0 = DynamicFrame.fromDF(df0, glueContext, "result0")
    return DynamicFrameCollection({"CustomTransform0": dyf0}, glueContext)


# Script generated for node Multiple Output
def CreateMultipleOutput(glueContext, dfc) -> DynamicFrameCollection:
    df = dfc.select(list(dfc.keys())[0]).toDF()
    from pyspark.sql import functions as f

    df.createOrReplaceTempView("inputTable")
    df0 = spark.sql(
        "SELECT TO_DATE(CAST(UNIX_TIMESTAMP(date, 'yyyyMMdd') AS TIMESTAMP)) as date, \
                            state , \
                            (positiveIncrease * 100 / totalTestResultsIncrease) as positivePercentage, \
                            StateName \
                    FROM inputTable "
    )

    df1 = df.withColumn(
        "CombinedName",
        f.concat(f.col("StateName"), f.lit("("), f.col("state"), f.lit(")")),
    )

    dyf0 = DynamicFrame.fromDF(df0, glueContext, "result0")
    dyf1 = DynamicFrame.fromDF(df1, glueContext, "result1")

    return DynamicFrameCollection(
        {"CustomTransform0": dyf0, "CustomTransform1": dyf1}, glueContext
    )


def sparkSqlQuery(glueContext, query, mapping, transformation_ctx) -> DynamicFrame:
    for alias, frame in mapping.items():
        frame.toDF().createOrReplaceTempView(alias)
    result = spark.sql(query)
    return DynamicFrame.fromDF(result, glueContext, transformation_ctx)


args = getResolvedOptions(sys.argv, ["JOB_NAME"])
sc = SparkContext()
glueContext = GlueContext(sc)
spark = glueContext.spark_session
job = Job(glueContext)
job.init(args["JOB_NAME"], args)

# Script generated for node COVID data
COVIDdata_node1689850872831 = glueContext.create_dynamic_frame.from_catalog(
    database="examples_glueimmersion_db",
    table_name="json",
    transformation_ctx="COVIDdata_node1689850872831",
)

# Script generated for node State Name
StateName_node1689850935540 = glueContext.create_dynamic_frame.from_options(
    format_options={"quoteChar": '"', "withHeader": True, "separator": ","},
    connection_type="s3",
    format="csv",
    connection_options={
        "paths": [
            "s3://glueworkshop-350261890139-ap-south-1/input/lab5/state/states.csv"
        ],
        "recurse": True,
    },
    transformation_ctx="StateName_node1689850935540",
)

# Script generated for node Join Data
SqlQuery0 = """
SELECT  coviddata.date,
        coviddata.state,
        coviddata.positiveincrease,
        coviddata.totaltestresultsincrease,
        statename.StateName
FROM    coviddata LEFT JOIN statename
        ON  coviddata.state = statename.Code
WHERE   coviddata.state in ('NY', 'CA')
"""
JoinData_node1689851048353 = sparkSqlQuery(
    glueContext,
    query=SqlQuery0,
    mapping={
        "coviddata": COVIDdata_node1689850872831,
        "statename": StateName_node1689850935540,
    },
    transformation_ctx="JoinData_node1689851048353",
)

# Script generated for node Multiple Output
MultipleOutput_node1689851621337 = CreateMultipleOutput(
    glueContext,
    DynamicFrameCollection(
        {"JoinData_node1689851048353": JoinData_node1689851048353}, glueContext
    ),
)

# Script generated for node Positive Percentage
PositivePercentage_node1689852290267 = SelectFromCollection.apply(
    dfc=MultipleOutput_node1689851621337,
    key=list(MultipleOutput_node1689851621337.keys())[0],
    transformation_ctx="PositivePercentage_node1689852290267",
)

# Script generated for node Increase cases
Increasecases_node1689852757032 = SelectFromCollection.apply(
    dfc=MultipleOutput_node1689851621337,
    key=list(MultipleOutput_node1689851621337.keys())[1],
    transformation_ctx="Increasecases_node1689852757032",
)

# Script generated for node Pivot by state
SqlQuery1 = """
SELECT  date, positivePercentageNY, positivePercentageCA
FROM    positivepercentage 
        pivot (avg(positivePercentage) as positivePercentage 
        for state in ('NY' as positivePercentageNY, 'CA' as positivePercentageCA))
"""
Pivotbystate_node1689852341310 = sparkSqlQuery(
    glueContext,
    query=SqlQuery1,
    mapping={"positivepercentage": PositivePercentage_node1689852290267},
    transformation_ctx="Pivotbystate_node1689852341310",
)

# Script generated for node Aggregate Case Count
AggregateCaseCount_node1689852835581 = AggregateCaseCount(
    glueContext,
    DynamicFrameCollection(
        {"Increasecases_node1689852757032": Increasecases_node1689852757032},
        glueContext,
    ),
)

# Script generated for node aggregate result
aggregateresult_node1689852963006 = SelectFromCollection.apply(
    dfc=AggregateCaseCount_node1689852835581,
    key=list(AggregateCaseCount_node1689852835581.keys())[0],
    transformation_ctx="aggregateresult_node1689852963006",
)

# Script generated for node Amazon S3
AmazonS3_node1689852639281 = glueContext.write_dynamic_frame.from_options(
    frame=Pivotbystate_node1689852341310,
    connection_type="s3",
    format="json",
    connection_options={
        "path": "s3://glueworkshop-350261890139-ap-south-1/output/lab5/advance/pivot/",
        "partitionKeys": [],
    },
    transformation_ctx="AmazonS3_node1689852639281",
)

# Script generated for node Amazon S3
AmazonS3_node1689853088512 = glueContext.write_dynamic_frame.from_options(
    frame=aggregateresult_node1689852963006,
    connection_type="s3",
    format="json",
    connection_options={
        "path": "s3://glueworkshop-350261890139-ap-south-1/output/lab5/advance/aggregate/",
        "partitionKeys": [],
    },
    transformation_ctx="AmazonS3_node1689853088512",
)

job.commit()
