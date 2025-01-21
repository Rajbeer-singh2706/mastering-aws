
#GLue Job Creation and Initial Exection 

# Prepare S3 Bucket 
AWS_ACCOUNT_ID=`aws sts get-caller-identity --query Account --output text`
AWS_REGION=`aws configure get region`
BUCKET_NAME=glueworkshop-${AWS_ACCOUNT_ID}-${AWS_REGION}

echo "export BUCKET_NAME=\"${BUCKET_NAME}\"" >> /home/ec2-user/.bashrc
echo "export AWS_REGION=\"${AWS_REGION}\"" >> /home/ec2-user/.bashrc
echo "export AWS_ACCOUNT_ID=\"${AWS_ACCOUNT_ID}\"" >> /home/ec2-user/.bashrc

echo ${BUCKET_NAME}
echo ${AWS_REGION}
echo ${AWS_ACCOUNT_ID}

# Create Glue job source code file


Extra
------
SQLtable_node1 = glueContext.create_dynamic_frame.from_catalog(
    database="glueworkshop-cloudformation",
    table_name="lab5_rds_glueworkshop_orders",
    transformation_ctx="SQLtable_node1",
    additional_options = {"jobBookmarkKeys":["orderid"],"jobBookmarkKeysSortOrder":"asc"}
)


###Create the Glue job to load data from RDS to S3
cd ~/environment
aws s3 cp job_bookmark_rds_s3.py s3://${BUCKET_NAME}/script/lab10/job_bookmark_rds_s3.py
aws glue create-job \
    --name glueworkshop-lab10-etl-job \
    --role AWSGlueServiceRole-glueworkshop \
    --command "Name=glueetl,ScriptLocation=s3://${BUCKET_NAME}/script/lab10/job_bookmark_rds_s3.py,PythonVersion=3" \
    --glue-version '3.0' \
    --connections Connections='lab5-rds-connection' \
    --default-arguments "{ \
    \"--s3_bucket_name\": \"${BUCKET_NAME}\", \
    \"--region_name\": \"${AWS_REGION}\", \
    \"--enable-metrics\": \"\", \
    \"--enable-spark-ui\": \"true\", \
    \"--TempDir\": \"s3://${BUCKET_NAME}/output/lab5/temp/\", \
    \"--TargetDir\": \"s3://${BUCKET_NAME}/output/lab10/orders/\", \
    \"--spark-event-logs-path\": \"s3://${BUCKET_NAME}/output/lab5/sparklog/\" \
    }" \
    --number-of-workers 4 \
    --worker-type Standard

# Enable Job Bookmark and run the Glue job
JOb : glueworkshop-lab09-etl-job.

# aws glue start-job-run \
    --job-name glueworkshop-lab09-etl-job 

# aws glue start-job-run \
    --job-name glueworkshop-lab09-etl-job 



