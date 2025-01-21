###### Using Athena #########
# ${BUCKET_NAME}

CREATE DATABASE IF NOT EXISTS athena_glueworkshop;

#Create Tables
CREATE EXTERNAL TABLE IF NOT EXISTS athena_glueworkshop.athena_csv
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
ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.OpenCSVSerde'
 WITH SERDEPROPERTIES (
   'separatorChar' = ',',
   'quoteChar' = '\"',
   'escapeChar' = '\\'
   )
STORED AS TEXTFILE
LOCATION 's3://glueworkshop-350261890139-ap-south-1/input/lab1/csv/'
TBLPROPERTIES (
  "skip.header.line.count"="1")

# 
SELECT * FROM "athena_glueworkshop"."athena_csv" limit 10;

#
CREATE EXTERNAL TABLE IF NOT EXISTS athena_glueworkshop.athena_json
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
 ROW FORMAT SERDE 'org.openx.data.jsonserde.JsonSerDe'
 WITH SERDEPROPERTIES ('ignore.malformed.json' = 'true')
STORED AS TEXTFILE
LOCATION 's3://${BUCKET_NAME}/input/lab5/json/'

#SELECT * FROM "athena_glueworkshop"."athena_json" limit 10;

