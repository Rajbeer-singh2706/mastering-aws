# Glue Databrew Dataset

Follow the steps below to create a new DataBrew dataset

#1. Click the DATASETS icon on the left.
#2. Click the Connect new dataset button in the middle.
#3. Under New dataset details set Dataset name to covid-testing.
#4. Under Connect to new dataset click Data Catalog S3 tables under AWS Glue Data Catalog on the left, 
click cli_glueworkshop, and click the radio button next to cli_json.
#5. Click Create dataset.


Once the new dataset is created, we will run the profiling job on the new dataset. When you profile your data, DataBrew creates a report called a data profile. This summary tells you about the existing shape of your data, including the context of the content, the structure of the data, and its relationships. You can make a data profile for any dataset by running a data profile job.

Click the checkbox next to the dataset.

Click ▶ Run data profile on the top.

Click Create profile job to open Create job page.

Under Job details, set Job name to covid-testing-profile-job.

Under Job run sample select Full dataset.

Under Job output settings set the S3 location to s3://${BUCKET_NAME}/output/lab5/profile/ (replace ${BUCKET_NAME} with your own bucket name).

Under Permission (scroll at the end), select AWSGlueDataBrewServiceRole-glueworkshop for Role name.

Click Create and run job.

The profile job takes about 5 minutes. Once the job finishes, go to the covid-testing dataset and click the Data profile overview tab. Here you can explore the data profile information created by the profiling job.

From the correlation coefficient, you can see positive has high correlation to death and hospitalization.

#16. At the bottom of the tab, you can see detailed information about each column, including data type, cardinality, data quality, distribution, min/max value and others. You can also click on each column to get more detailed statistics about an individual column.
#17. Click the Data lineage tab. You can find the data lineage information here. In later section of this lab, you will also examine how data lineage is tracked for transformation jobs.