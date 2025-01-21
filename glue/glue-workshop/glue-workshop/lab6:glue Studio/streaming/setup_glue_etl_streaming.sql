3. Glue Studio Streaming JOB 
----------------------------------

Source > Transformation > Target 

Name: glueworkshop-lab6-streaming-job
Role AWSGlueServiceRole-glueworkshop 
workers:2  
Job bookmark select Disable and
click Save. 

########################## SOurces ############################

Source1 
-------
Source: Amazon Kinesis 
Amazon Kinesis Source: Data Catalog table
Dtabase: examples 
tbale: example2_table


Source2:
----------
SOurce: S3
S3 Source Type: S3 Location 
S3 URL: s3://glueworkshop-raj-14072023/input/lab6/country_lookup/
Data Format(JSON/CSV/parquet/hudi/delta lake)   ; CSV
Infer Schema 


########################## Transformation ############################
1. Join 
2. DropFields 

########### Target ########
Target: S3
Format : CSV 
Compression
S3 Target Location: s3://glueworkshop-raj-14072023/output/lab6/streamingoutput/
Data Catalog update optionsInfo: Do not update the Data Catalog


############### Commands  #########

cd ~/environment/glue-workshop
python ~/environment/glue-workshop/code/lab4/PutRecord_Kinesis.py 
aws s3 cp s3://${BUCKET_NAME}/output/ ~/environment/glue-workshop/output --recursive



