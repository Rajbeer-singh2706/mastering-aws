
##### Create Glue Studio Job ######
Name: glueworkshop-lab6-etl-job
IAM : AWSGlueServiceRole-glueworkshop


Source 
--------
Source : S3
Source Type: Data Catalog


Transform
----------
1.Custom Transformation 

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


2. Select from Collection 

Target 
-----
S3 