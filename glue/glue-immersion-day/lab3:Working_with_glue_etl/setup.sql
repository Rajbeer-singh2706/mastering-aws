aws glue start-job-run --job-name glueworkshop-lab3-etl-ddb-joblab04

json-streaming-table

Job Name: 
1. glueimmersion-lab3-etl-job
2. glueworkshop-lab3-etl-ddb-job

########## Job1 ########### 
Name: glueimmersion-lab3-etl-job
Type: Spark 
Glue Version: 3.0
Lanugage: Python3
WorkerType: G1.x
Requested number of workers: 2
Job BookMark: Disable
Copy paste the spark.py script 

Advance Properties 
==================
Job Parameters: 
--s3_bucket : s3://glueworkshop-350261890139-ap-south-1/
s3://glueworkshop-350261890139-ap-south-1

Add this into Python Library Path 
s3://glueworkshop-350261890139-ap-south-1/library/pycountry_convert.zip

######## need to test 
--extra-py-files: s3://glueworkshop-350261890139-ap-south-1/library/pycountry_convert.zip
##########



################ Job2: Outputting to DynamoDB ############

########## Job2 ########### 
Name: glueimmersion-lab3-etl-ddb-job
Type: Spark 
Glue Version: 3.0
Lanugage: Python3
WorkerType: G1.x
Requested number of workers: 2
Job BookMark: Disable
Copy paste the spark-ddb.py script 

Advance Properties 
==================
Job Parameters: 
--s3_bucket_name : glueworkshop-350261890139-ap-south-1
--ddb_table_name : glueworkshop-lab3
--region_name : ap-south-1

Add this into Python Library Path 
s3://glueworkshop-350261890139-ap-south-1/library/pycountry_convert.zip

####### Run using CLI #####
aws glue start-job-run --job-name glueworkshop-lab3-etl-ddb-job