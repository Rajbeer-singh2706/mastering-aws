######## Lab3: GLUE ETLC JOB #########

1. Develop Code 
2. Deploy Glue ETL Job 

aws glue create-job \
    --name glueworkshop-lab3-etl-testing \
    --role AWSGlueServiceRole-glueworkshop \
    --command "Name=glueetl,ScriptLocation=s3://glueworkshop-raj-14072023/script/lab3/spark.py,PythonVersion=3" \
    --glue-version '3.0' \
    --default-arguments "{\"--extra-py-files\": \"s3://glueworkshop-raj-14072023/library/pycountry_convert.zip\", \
        \"--s3_bucket\": \"s3://glueworkshop-raj-14072023/\" }" \
    --region ap-south-1


aws glue list-job 
aws glue get-job --job-name glueworkshop-lab3-etl-testing
 

3. Run Glue ETL Job 
aws s3 cp s3://${BUCKET_NAME}/output/ ~/environment/glue-workshop/output --recursive


4. Create Glue Trigger 
--------------------------
Trigger Name: glueworkshop-lab3-etl-job-trigger
Trigger Type: schedule
Frequencey: Hourly 
Start Mintue: 00 
Choose Job/Trugger: Job 
Job Name: glueworkshop-lab3-etl-testing

Activate Trigger 

########### 