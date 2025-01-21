ETL JOB 
------
You can create Glue extract, transform, and load (ETL) jobs with Glue Studio. When creating an ETL job in AWS Glue 
Studio, you can choose from a variety of data sources that are stored in AWS services. You can quickly prepare 
that data for analysis with provided transformations. AWS Glue Studio also offers tools to monitor ETL 
workflows and validate that they are operating as intended. You can preview the dataset for each node. 
This helps you to debug your ETL jobs by displaying a sample of the data at each step of the job. AWS Glue 
Studio provides a visual interface that makes it easy to:

- Pull data from an Amazon S3, Glue Data Catalog, or JDBC source.
- Configure a transformation that joins, samples, or transforms the data.
- Specify a target location for the transformed data.
- View the schema or a sample of the dataset at each point in the job.
- Run, monitor, and manage the jobs created in AWS Glue Studio.

In this section, we will show you have to create an ETL job in Glue Studio visual interface.

###################################
Souce1
-------
Souce:AWS Glue Data Catalog
Database: examples_glueimmersion_db
Table:json
Name: COVID data

Source2
--------
Source: S3
Name: state_name
S3 location: s3://glueworkshop-350261890139-ap-south-1/input/lab5/state/
Data Format: csv 
Click Infer schema

Transform
===========
1. drop_fields
-----------
    - date
    - state
    - deathincrease
    - hospitalizeincrease

2. filter
-------
- state matched [ NY|CA ]


3. Change Schema 
-------------
- deathincrease:int
- hospitalizedincrease: int

4. Join 
--------
Join Type: Left 
Node Parents => [ state_name, Change_Schema ]
Join Condition 
Change Schema: state
State_name: code

5. Aggregate
-------------
Fields to group by - state
Fields to Aggregate
- deathincrease        : sum 
- hospitalizedincrease : sum 

Target 
=======
Click Target Amazon S3.
Format: JSON
Compression Type: sNone
S3 Target Location: s3://glueworkshop-350261890139-ap-south-1/output/



##
aws s3 cp s3://${BUCKET_NAME}/output/lab5/ ~/environment/glue-workshop/output/lab5 --recursive

