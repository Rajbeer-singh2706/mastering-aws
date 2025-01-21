########## Advance Transformation ##########
Job Name: glueworkshop-lab5-advance-job



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

########### Transform ###########
1. SQL Query 
-------------
Name: Join Data 
Node parents : COVID Data, State Name 
Set Input sources COVID data :coviddata
Set Input sources State Name :statename

SQL Quey : 
SELECT  coviddata.date,
        coviddata.state,
        coviddata.positiveincrease,
        coviddata.totaltestresultsincrease,
        statename.StateName
FROM    coviddata LEFT JOIN statename
        ON  coviddata.state = statename.Code
WHERE   coviddata.state in ('NY', 'CA')

Click Output schema tab, click Edit and set the output 1 schema as the following. 
Click ... dropdown and Add root key to add new field in output schema.
For the new field set Key as StateName
Set Data Type as string
Click Apply.

2. Custom Transform 
----------------
Name: Multiple Output
def CreateMultipleOutput (glueContext, dfc) -> DynamicFrameCollection:
   pass 
  

3. Select From Collection
-------------------------
Name:Positive Percentage
FrameIndex:0


4. SQL Query 
-------------
Name: Pivot by State
Node parents : Positive Percentage
InputSources Positive Percentage : positivepercentage


Target 
=======
Click Target Amazon S3.
Format: JSON
Compression Type: None
S3 Target Location: s3://glueworkshop-350261890139-ap-south-1/output/lab5/advance/pivot

Transform 
-----------
4. Select From Collection
-------------------------
Name:Increase cases
NodeParent: Multiple Output
FrameIndex:1


5. Custom Transform 
----------------
Name: Aggregate Case Count
def AggregateCaseCount (glueContext, dfc) -> DynamicFrameCollection:
   pass 
   
3. Select From Collection
-------------------------
Name:Positive Percentage
NodeParent: Aggregate Case Count
FrameIndex:0

Target 
=======
Click Target Amazon S3.
Format: JSON
Compression Type: None
S3 Target Location: s3://glueworkshop-350261890139-ap-south-1/output/lab5/advance/aggregate


aws s3 cp s3://${BUCKET_NAME}/output/lab5/ ~/environment/glue-workshop/output/lab5 --recursive
