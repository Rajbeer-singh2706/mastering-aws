# Optional: Glue Job bookmarks with S3 source

# Create Glue Job source Code FIle 

# Deploy and run Glue job to load data from S3 Json files to S3 parquet files

cd ~/environment
aws s3 cp job_bookmark_s3.py s3://${BUCKET_NAME}/script/lab10/job_bookmark_s3.py
aws glue create-job \
    --name glueworkshop-lab10-s3-job \
    --role AWSGlueServiceRole-glueworkshop \
    --command "Name=glueetl,ScriptLocation=s3://${BUCKET_NAME}/script/lab10/job_bookmark_s3.py,PythonVersion=3" \
    --glue-version '3.0' \
    --default-arguments "{ \
    \"--s3_bucket_name\": \"${BUCKET_NAME}\", \
    \"--region_name\": \"${AWS_REGION}\", \
    \"--enable-metrics\": \"\", \
    \"--enable-spark-ui\": \"true\", \
    \"--TempDir\": \"s3://${BUCKET_NAME}/output/lab10/temp/\", \
    \"--TargetDir\": \"s3://${BUCKET_NAME}/output/lab10/orders_parquet/\", \
    \"--job-bookmark-option\": \"job-bookmark-enable\" \
    }" \
    --number-of-workers 4 \
    --worker-type Standard

# Run Below Command 
aws glue start-job-run \
    --job-name glueworkshop-lab10-s3-job 

# We have now successfully loaded the data from S3 Json folder to S3 Parquet
folder and also added a new Glue table orders_parquet to the Glue Data Catalog.
We can verify the newly added table by clicking Glue catalog on the left menu, and then clicking on Tables, you should see a new table orders_parquet.

# aws glue start-job-run \
    --job-name glueworkshop-lab10-s3-job 

#10. 
Re-verify the results from Athena, results should remain the same. This shows 
that the data is not processed again if we enable Glue job bookmarks. You can
also check the output logs and verify the message indicating that zero records
were processed in this job run.
You can practice all the scenarios for reprocessing, rewinding and resetting the Job bookmarks with S3 
data source as well; and validate the behavior of Glue job. The steps are similar to the one we used in 
the earlier segment for source table in MySQL RDS database.

You have now completed the optional lab for using Glue job bookmark for 
processing source data in S3 bucket location.