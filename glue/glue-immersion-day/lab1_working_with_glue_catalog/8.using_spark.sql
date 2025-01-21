######### Using Spark ###########
%extra_jars s3://crawler-public/json/serde/json-serde.jar

import sys
from awsglue.transforms import *
from awsglue.utils import getResolvedOptions
from pyspark.context import SparkContext
from awsglue.context import GlueContext
from awsglue.job import Job
  
sc = SparkContext.getOrCreate()
glueContext = GlueContext(sc)
spark = glueContext.spark_session
job = Job(glueContext)

spark.sql("show databases").show()

%%sql 
show databases


%%sql
create database if not exists spark_glueworkshop

%%sql
CREATE EXTERNAL TABLE IF NOT EXISTS spark_glueworkshop.spark_csv
(
uuid bigint,
Country string,
item_type string,
sales_channel string,
order_priority string, 
order_date string,
region string,
ship_date string,
units_sold bigint,
unit_price double,
unit_cost double,
total_revenue double,
total_cost double,
total_profit double
  ) 
    STORED AS TEXTFILE
    LOCATION 's3://${BUCKET_NAME}/input/lab1/csv/'
    ROW FORMAT DELIMITED 
    FIELDS TERMINATED BY ',' 
    LINES TERMINATED BY '\n'
TBLPROPERTIES (
  "skip.header.line.count"="1")


%%sql

SELECT * from  spark_glueworkshop.spark_csv limit 10

%%sql
CREATE EXTERNAL TABLE IF NOT EXISTS spark_glueworkshop.spark_json
(
date string,
state string,
positive double,
hospitalized double,
death double,
total double,
hash string,
datechecked string,
totaltestresults double,
fips string,
deathincrease double,
hospitalizedincrease double,
negativeincrease double,
positiveincrease double,
totaltestresultsincrease double,
negative double,
pending double
  ) 
    STORED AS TEXTFILE
    LOCATION 's3://${BUCKET_NAME}/input/lab5/json/'
    ROW FORMAT SERDE 'org.openx.data.jsonserde.JsonSerDe'


%%sql 
SELECT * from  spark_glueworkshop.spark_json limit 10