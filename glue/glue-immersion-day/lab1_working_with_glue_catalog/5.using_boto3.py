# Optional: Using Python Boto3 library
head ~/environment/glue-immersion-day/lab1_working_with_glue_catalog/csv/sample.csv

import boto3

BUCKET_NAME = "glueworkshop-350261890139-ap-south-1"

client = boto3.client('glue')

# Create database 
try:
    response = client.create_database(
        DatabaseInput={
            'Name': 'python_glueworkshop',
            'Description': 'This database is created using Python boto3',
        }
    )
    print("Successfully created database")
except:
    print("error in creating database")

#Create Crawlers
try:
    response = client.create_crawler(
        Name='python-lab1',
        Role='AWSGlueServiceRole-glueworkshop',
        DatabaseName='python_glueworkshop',
        Targets={
            'S3Targets': [
                {
                    'Path': 's3://{BUCKET_NAME}/input/lab1/csv'.format(BUCKET_NAME = BUCKET_NAME),
                },
                {
                    'Path': 's3://{BUCKET_NAME}/input/lab5/json'.format(BUCKET_NAME = BUCKET_NAME),
                }
            ]
        },
        TablePrefix='python_'
    )
    print("Successfully created crawler")
except:
    print("error in creating crawler")


#Start Crawlers
# This is the command to start the Crawler
try:
    response = client.start_crawler(
        Name='python-lab1'
    )
    print("Successfully started crawler")
except:
    print("error in starting crawler")


##Execute the python script
python ~/environment/glue-workshop/code/lab1/glue_crawler.py
