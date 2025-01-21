

# Lab4 : Glue Streaming Job 
===============================
 - Amazon Kinesis Data Stream 
 - Apache Kafka 
 - Amazon Managed Streaming for Apache Kafka(MSK)

Glue Streaming 
---------------
- Micro Batch 
- Tumbling Window 
######
 - data/country_loopup/country_lookup.csv , its has some special characters as well .

###Job Name: glueworkshop_lab4_glue_streaming

Source : S3  
===============
1. S3 
2. GlueCatalog [ examples,example2_table ]

Transformation 
--------------
=> Change Schema/Apply Mapping 
=> Join 
   * Join.apply(apply_mapping, country_lookup_frame, 'Source_fields', 'TargertField')
=> DropFields

Data Target 
----------
1. S3 Bucket

#############################

###### Deploy Glue Streaming Job ######
aws glue create-job \
    --name glueworkshop_lab4_glue_streaming \
    --role AWSGlueServiceRole-glueworkshop  \
    --command "Name=gluestreaming,ScriptLocation=s3://${BUCKET_NAME}/script/lab4/streaming.py,PythonVersion=3" \
    --glue-version "2.0" \
    --default-arguments "{\"--s3_bucket\": \"s3://${BUCKET_NAME}/\" }" \
    --region us-east-2


########### RUN Glue Streaming Job ######

#### Run Kinesis#######
sudo pip3 install boto3
cd ~/environment/glue-workshop
python ~/environment/glue-workshop/code/lab4/PutRecord_Kinesis.py 


##### Check the Output 
aws s3 cp s3://${BUCKET_NAME}/output/ ~/environment/glue-workshop/output --recursive


############################
Things to do Later 
------------------
- can we use broadcast Join Here 
- Complete streaming framework can be developed with this example #### Beginner to Expert #####
- No need to run for 100 example, 1 example we have make it rbust and end to end ...