############ Example ##########

def CustomTransform (glueContext, dfc) -> DynamicFrameCollection:
    df0 = dfc.select(list(dfc.keys())[0]).toDF()
    df1 = dfc.select(list(dfc.keys())[1]).toDF()
    ...

    # do transformation on the Spark DataFrame df0, df1, ... 
    ...
    
    # The result DataFrames named have names like resultDF0, resultDF1, ... in the end
    # Convert them to DynamicFrame and return in a DynamicFrameCollection

    dyf0 = DynamicFrame.fromDF(resultDF, glueContext, "result0")
    dyf1 = DynamicFrame.fromDF(resultDF, glueContext, "result1")
    ...
    return(DynamicFrameCollection(  {
                                    "CustomTransform0": dyf0,
                                    "CustomTransform1": dyf1,
                                    ...
                                    }, 
                                    glueContext))
''

DataSource0 = glueContext.create_dynamic_frame.from_options(
    format_options = {"jsonPath":"","multiline":False}, 
    connection_type = "s3", 
    format = "json", 
    connection_options = {"paths": ["s3://${BUCKET_NAME}/output/lab6/json/temp1/"], "recursive":True}, 
    transformation_ctx = "DataSource0")

sparkDF = DataSource0.toDF()
sparkDF.createOrReplaceTempView("inputTable")
sparkDF.printSchema()
sparkDF.show(10)


df = spark.sql("select TO_DATE(CAST(UNIX_TIMESTAMP(date, 'yyyyMMdd') AS TIMESTAMP)) as date, \
                       state , \
                       positiveIncrease ,  \
                       totalTestResultsIncrease \
                from   inputTable")
df.printSchema()
df.show(10)

#############
def ConvertDateStringToDate (glueContext, dfc) -> DynamicFrameCollection:
    sparkDF = dfc.select(list(dfc.keys())[0]).toDF()
    sparkDF.createOrReplaceTempView("inputTable")

    df = spark.sql("select TO_DATE(CAST(UNIX_TIMESTAMP(date, 'yyyyMMdd') AS TIMESTAMP)) as date, \
                           state , \
                           positiveIncrease ,  \
                           totalTestResultsIncrease \
                    from   inputTable")

    dyf = DynamicFrame.fromDF(df, glueContext, "results")
    return DynamicFrameCollection({"CustomTransform0": dyf}, glueContext)

Transform = ConvertDateStringToDate(glueContext, DynamicFrameCollection({"DataSource0": DataSource0}, glueContext))
resultDF = Transform.select(list(Transform.keys())[0]).toDF()
resultDF.printSchema()
resultDF.show(10)

############### Custom Transformation1 #########
def DeleteFields (glueContext, dfc) -> DynamicFrameCollection:
    sparkDF = dfc.select(list(dfc.keys())[0]).toDF()
    sparkDF.createOrReplaceTempView("covidtesting")
    
    df = spark.sql("select  date, \
                            state , \
                            positiveIncrease ,  \
                            totalTestResultsIncrease \
                    from covidtesting")
    
    dyf = DynamicFrame.fromDF(df, glueContext, "results")
    return DynamicFrameCollection({"CustomTransform0": dyf}, glueContext)
    
    

############### Custom Transformation2 #########
def ConvertDateStringToDate (glueContext, dfc) -> DynamicFrameCollection:
    sparkDF = dfc.select(list(dfc.keys())[0]).toDF()
    sparkDF.createOrReplaceTempView("inputTable")

    df = spark.sql("select TO_DATE(CAST(UNIX_TIMESTAMP(date, 'yyyyMMdd') AS TIMESTAMP)) as date, \
                           state , \
                           positiveIncrease ,  \
                           totalTestResultsIncrease \
                    from   inputTable")

    dyf = DynamicFrame.fromDF(df, glueContext, "results")
    return DynamicFrameCollection({"CustomTransform0": dyf}, glueContext)

############### Custom Transformation3 #########
def FilterAndCalculatePercentage (glueContext, dfc) -> DynamicFrameCollection:
    sparkDF = dfc.select(list(dfc.keys())[0]).toDF()
    sparkDF.createOrReplaceTempView("inputTable")

    df = spark.sql("select  date , \
                            state , \
                            (positiveIncrease * 100 / totalTestResultsIncrease) as positivePercentage \
                    from inputTable \
                    where state in ('NY', 'CA')")

    dyf = DynamicFrame.fromDF(df, glueContext, "results")
    return DynamicFrameCollection({"CustomTransform0": dyf}, glueContext)

############### Custom Transformation4 #########
def PivotValue (glueContext, dfc) -> DynamicFrameCollection:
    sparkDF = dfc.select(list(dfc.keys())[0]).toDF()
    sparkDF.createOrReplaceTempView("inputTable")

    df = spark.sql("select * from inputTable \
                    pivot (avg(positivePercentage) as positivePercentage \
                    for state in ('NY' as positivePercentageNY, 'CA' as positivePercentageCA))")

    dyf = DynamicFrame.fromDF(df, glueContext, "results")
    return DynamicFrameCollection({"CustomTransform0": dyf}, glueContext)


################
###### aws s3 cp s3://${BUCKET_NAME}/output/ ~/environment/glue-workshop/output --recursive
