####### Glue Streaming #######
- using Tumbling Window Concept 
glueworkshop-lab4-etl-job.i



Glue Table
------------
DB             : examples_glueimmersion_db
Table          : example2_table
Kineis Stream  : glueimmersion 
NoteBook       : glueimmersion-lab4-etl-job
Bucket Name    : glueworkshop-350261890139-ap-south-1


Create New JOB 
-------------
In Job details section
Set Name to glueimmersion-lab4-glue-streaming
Set IAM role to AWSGlueServiceRole-glueimmersion
Set Type to Spark Streaming
Set Glue Version to Glue 3.0 - Supports Spark 3.1, Scala 2, Python 3
Set Number of retries to 0

Advance Properties 
------------------
--s3_bucket 

aws glue create-job \
    --name glueimmersion-lab4-glue-streaming \
    --role AWSGlueServiceRole-glueimmersion  \
    --command "Name=gluestreaming,ScriptLocation=s3://${BUCKET_NAME}/script/lab4/streaming.py,PythonVersion=3" \
    --glue-version "3.0" \
    --default-arguments "{ \
    \"--s3_bucket\": \"s3://${BUCKET_NAME}/\", \
    \"--enable-metrics\": \"\", \
    \"--enable-spark-ui\": \"true\", \
    \"--TempDir\": \"s3://${BUCKET_NAME}/output/lab4/temp/\", \
    \"--spark-event-logs-path\": \"s3://${BUCKET_NAME}/output/lab4/sparklog/\" \
    }" \
    --number-of-workers 2 \
    --worker-type G.1X

aws glue start-job-run --job-name glueworkshop-lab4-glue-streaming
aws s3 cp s3://${BUCKET_NAME}/output/lab4/ ~/environment/glue-workshop/output/lab4 --recursive


set data to Kinesis 
-----------------------
cd ~/environment/glue-workshop
python ~/environment/glue-workshop/code/lab4/PutRecord_Kinesis.py 


######### RUn ############
cd script 
python3 PutkIneisis.py
