### Working with Streaming ETL Job #######

Kineisis
-----------
Data stream name: glueworkshop
Provisioned
Provisioned shards: 1
Create Data Stream


Visual Editor 
Job Name: glueworkshop-lab5-streaming-job

########### Source #########
Source : Amazon Kinesis.
Under Data source properties: Kinesis Stream tab
Amazon Kinesis Source       :Data Catalog table
Database                    :examples_glueimmersion_db
Table                       : lab5_kinesis
Starting position           : Latest
Window size                 : 100

** Uncheck Detect schema because we already defined the schema earlier

########### Source2 #########
Source: S3 
Name: country_lookup
S3 Source Type: S3 Location
S3 url: s3://glueworkshop-350261890139-ap-south-1/input/lab6/country_lookup/country_lookup.csv
Data format: CSV

Click Infer schema button

############## Transform ##############
Transform: Join 
Under Node parents and select both nodes
Join type to Left join
Under Join conditions : Add conditions
country:  Amazon Kinesis
CountryName:  country_lookup

############## Transform ##############
Transform: dropFields 
drop theses fields 
orderpriority
orderdate
region
shipdate
unitssold
unitprice
unitcost
CountryName

######## Target ########
Target: S3 
Format: CSV 
Compression: None
Target Location: s3://glueworkshop-350261890139-ap-south-1/output/lab5/streamingoutput/



########## RUN ##########
/home/ec2-user/environment/glue-immersion-day/lab4:glue_streaming/script
python3 PutRecord_Kinesis.py 
