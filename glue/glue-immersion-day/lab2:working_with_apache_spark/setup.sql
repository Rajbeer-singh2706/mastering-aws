


### Strcutrue streaming for incremental computation 
#### Spark RDD #####
- resilient distributed dataset 

Job: lab02_apache_spark_rdd


### Spark Dataframe#####
# Working with Spark Dataframes
- Datasets 
- Dataframe

#### Creating dataframe ####
df = spark.read.load("s3://${BUCKET_NAME}/input/lab2/sample.csv", 
                          format="csv", 
                          sep=",", 
                          inferSchema="true",
                          header="true")

type(df)

#DataFrame Operations

######## Using 3rd Party Libary & Data Catalog #####



