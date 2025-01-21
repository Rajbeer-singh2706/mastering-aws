## URL: https://catalog.us-east-1.prod.workshops.aws/workshops/aaaabcab-5e1e-4bff-b604-781a804763e1/en-US/lab1



IAM ROle 
--------
AWSGlueServiceRole-glueworkshop


####### Glue Data Catalog #############
head ~/environment/glue-workshop/lab1/data/csv/sample.csv


Database: glueworkshop-db


####### Create Data Crawler  #############
Name: lab1_csv_json_crawler
s3://glueworkshop-raj-14072023/input/lab1/


######## Once done , we can think automate or write CFN template for this ###################
