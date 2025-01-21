URL: https://tigeranalytics.udemy.com/course/aws-glue-the-complete-masterclass/learn/lecture/35037588#overview
https://catalog.us-east-1.prod.workshops.aws/workshops/aaaabcab-5e1e-4bff-b604-781a804763e1/en-US/prerequisites

########## Section 1: Introduction #############
########## Section 2: Glue Resourcs Setup Part1-IAM , KMS , SNS #########

IAM: AUthentication, Authorization and Identities 
# IAMUser: 
   - test101
# usergroup: usergroup101, AdministratorAccess 

# IAMRole: 
  - Trusted Entity: AWs Service 
  - Use Case: Glue 
  - Add Permission: AWSGlueServiceRole
  - Name: Role101 
  - Create 

# IAMPolicy 
  - Customer Managed  Policy  
      * Two Type [] Inline , Managed ]
  - AWS Managed Policy 
  Two Type of Policy 
    - Identity Based Policy 
    - Resource Based Policy 

# KMS: 
  - customer managed 

# SNS
  - sns101 
  Create topic 
  - create subscription , email

########## Section 3: Glue Resources Setup part2-S3, AWS CLI, Cloudformation and CloudWatch #####
# S3:
 - Name: bucket101-raj-10072023
 - AWS KMS Key: -> choose our key 
 - Permission: 
    
# AWS CLI: 
 $ aws iam list-users 

# AWS CLoudFormation: 
 https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/sample-templates-services-us-west-2.html

########## Section 4: Creating Bucket and Uploading Data for the Course ###########
# S3: 
  - glue-testing-etl-targets: 
  - crawlerfiles20june2023   : for the crawler source files 
  - glue-testing-etl-artifacts: For ETL Code and other files 
  - glue-testng-cfn-templates : For Cloud Formation Templates 

# Uload the crawlerfiles: crawlerfiles20june2023
G:\My Drive\DOCS\UDEMY_courses\AWS\aws-glue-masterclass\crawlerfiles

######################################################################################
########## Section 5: GLue Resources Setup - Glue catalog, Crawler ####################
######################################################################################
#22 AWS Data Catalog 
 - databases
 - Tables
 - Schema REgistry : For the Streaming Jobs 
 - Connections
 - Crawlers 
 ####

 https://docs.aws.amazon.com/glue/latest/dg/catalog-and-crawler.html

# database: database101

#23. AWS GLUE Crawler #

#24. AWS Glue Classifier ####
- https://docs.aws.amazon.com/glue/latest/dg/custom-classifier.html#custom-classifier-json
- clasfier:101 

#25. crawler lab - First Glue Crawler Creation  => lab1_crawler 
#26. crawler lab - Second Glue Crawler Creation =? lab2_crawler ** improtant 
#27. crawler lab - Third Glue Crawler Creation  => lab3_crawler 
#28. crawler lab - Fourth Glue Crawler Creation => lab4_crawler ** 
 historical
 historical-year 

#30. crawler lab - Fourth Glue Crawler Creation => lab4_current_crawler ** 
 ** current

#31. AWS GLUE JOB 101 
 * script location 
 * Python Librayr Path 
     - egg file python , if u have more libraries
 * Bookmarks
 * Retries 
 * Parameters- u can specify any parameters such s3 sources, s3 destination etc..
 * Job Type 
        * Python Shell Job [DPU - data processing unit 1 DPU provides vCPU and 16GB of Memory ]
        * Spark JOb - Scala or Python
  * GLUE ETL 
     * Type - spark , spark streaming 
     * Glue verson: comes with associated Python, scala and Spark Version 
     * Langue: py, sc
     * Worker Type: G.1X,G.2X
     * Request number of worker 

Glue Job 
-----------
- Python shell script job 
    https://docs.aws.amazon.com/glue/latest/dg/aws-glue-programming-python-libraries.html

#32 GLUE Trigger 101 
 - like as cronjob
  Two Types 
   - Scheduled Trigger 
   - Conditional/Event Based Trigger 
 
- Trigger : 
   Name: scheduled101, daily, Type: scheduled
   Job to Start: etl-job-101
   
#33. AWS GLue Workflow 101 
 - orchestration the trigger

*** Cgeck this video again to create my own way .

########## Section 6: CloudFormation Templates ###########
#36. Cloudformation template 101 
- Review 
- Update 
- Upload 
- Debugging 

#37. First Glue Pipeline - CFN Templates 
- aws-glue-masterclass/glujob-template/gluejob1/ 
  
#38. Second Glue Pipeline - CFN Templates 
 - create crawler here 
 - create template for 
  * Glue Job 
  * Trigger 
  * Workfow 

# 39. Glue Job 345 - CFN Template 
# 41. Upload CFN to AWS S3: refer notebook 

########## Section 7: First AWS Glue Pipeline Creation ###
# 43. Gettgin Ready for Glue Pipelie Creation 
S3 Buckets 
  - 
  - 
  - 

# 44. Deploying Glue Pipeline Stack using CLoudFormation
aws cloudformation create-stack \  
--stack-name gluejobrole-CFN \ 
--template-url https://glue-testing-cfn-templates.s3.ap-south-1.amazonaws.com/gluejob-templates/gluejob1/cfniamrole1.json \
--capabilities CAPABILITY_NAMED_IAM \
--region ap-south-1 \
-- profile awsdemo=

# 46. Analyzing Glue Job Script And Running Then Job 
# 47. Going Through The Log And Verifying Job Output 

--- Glue Job1 read from CSV table and write to S3 Bucket in Parquet Format 
--  Glue job2 read from csv file in source folder and Write to parqet format in S3 bucket 

########## Section 8: AWS Glue Job Debugging #############
- Runing glue job Workflow which will run the glue job and Crawler 
- Launch Error 
- Script Error 
- Access Error 
- KMS Key Policy 
  - Resource based Policy 

########## Section 9: Glue Streaming Job #################
#57. Getting Ready for glue Streaming Pipeline 
  * GLue Job345(Streaming).
  * kineis Stream , Glue Tables, IAM Roles
  * GLueJob3 - Stream Generator  
  * GLueJob4 - Stream Loader Job 
  * GLueJob5 - Stream Transformer Job 

#58. Deployging Glue Streaming Job Infrastructure 
S3 Bucket 
-----------

#59. Lab - Creating Python Shell Glue Job For Stream Generation
#60. Lab - Creating Glue Streaming Loading Job
  -> creatintg with canvas

#61. Lab - Creating Glue Streaming Transformation job 
#63. Running Glue Streaming Generator JOb 
#64. Running Glue Streaming Transformation Job  

########## Section 10: Glue Data Quality #################
#67. Data Quality 101 
#68. Setting up data Quality Rule set 
Table > Data Qualityu > Run History >Recommendation runs > Recommened rules 
IAM Role: gluejobrole1 
Recommend Rules 
#69. Glue Job WIth Data Quality Check 
#71. Setting up Glue Data Quality Cloudwatch Metrics 
#72. Receiving Alerts for Data Quality Issues 
  - with SNS topic we get the notification if its fails 

########## Section 11: Glue Data Brew ####################
#74. Data Brew 101
#75. Create DataSource and profile Data 
  - setup dataset and run profiling on that dataset 
  
#76. Create Project and Review Data Profile Output 
#77. Create and Publish Recipe 
#78. Create Job by Using Published Recipe 

********** NEED to learn Developer guide completely , then only all the concepts will be clear
, for topic , Redshift, EMR, GLUE. ###############

