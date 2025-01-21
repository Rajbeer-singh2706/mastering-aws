######### Lab01: Working with Glue Data Catalog ###########
head ~/environment/glue-immersion-day/lab1/csv/sample.csv


Role
-------
- AWSGlueServiceRole-glueworkshop

Console
--------- 
DB : examples_glueimmersion_db

Crawler 
========
Name          : console-lab1-crawler
Data Source1  : s3://glueworkshop-867344451249-ap-south-1/input/lab1/csv/
Data Source2  : s3://glueworkshop-867344451249-ap-south-1/input/lab5/json/
Database      : examples_glueimmersion_db