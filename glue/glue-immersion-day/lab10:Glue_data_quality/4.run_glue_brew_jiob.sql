# Run Glue DataBrew Job
Create a new DataBrew job.

#1. Click JOBS on the left.
#2. Click Create Job button.
#3. Under Job details set the Job name to covid-testing-recipe-job.
#4. Under Job type select Create a recipe job.
#5. Under Job input select Run on Project. In Select a project 
select covid-testing from the list.
#6. Under Job output settings set S3 location to s3://${BUCKET_NAME}/output/lab5/csv/ replacing ${BUCKET_NAME} 
with your own S3 bucket name.
#7. Under Permission select AWSGlueDataBrewServiceRole-glueworkshop in Role name.
#8. Click Create and run job.
#9. Once the job has been created, click the JOB icon on the left. Under the 
Recipe jobs tab you will see a new job with name covid-testing-job in the 
Running state. Wait for the job to finish.
#10.Once the job finishes, click on the job name. You should see one succeeded
job run under Job run history tab. Click the Data lineage tab to see the data lineage graph for the job.
#11. You should see a new folder in S3 under s3://${BUCKET_NAME}/output/lab5/csv/ which contains the 
output of the job. Use the command below to copy the output files locally in Cloud9 and explore the output in Cloud9.
aws s3 cp s3://${BUCKET_NAME}/output/lab5/ ~/environment/glue-workshop/output/lab5 --recursive

