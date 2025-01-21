
############ Delta Lake ######################
Create
Update
Delete 


Delta lake Features include 

CREATE EXTERNAL TABLE IF NOT EXISTS examples.sales
 LOCATION "s3://raj-retail/deltalake/base_table/"
 TBLPROPERTIES ('table_type' = 'DELTA');
 
 
 