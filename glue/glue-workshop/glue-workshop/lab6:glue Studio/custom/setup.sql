
JOb : glueworkshop-custom-lab6-etl-job


########################## SOurces ############################

Source:
----------
Source: S3
S3 Source Type: Data Catalog Table
Database: 
Table: json 

########################## Transformation ############################
1. Custom Transform : drop_fields
2. Custom Transform : convert_string_to_date  
3. Custom Transform : filter_and_calc_perc
4. Custom Transform : pivot_value

5. Select From Collection, 4 times 



########### Target ########
Target: S3
Format : JSON 
Compression: None
S3 Target Location: s3://glueworkshop-raj-14072023/output/lab6/temp1/
Data Catalog update optionsInfo: Do not update the Data Catalog