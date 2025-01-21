import boto3 

BUCKET_NAME="glueworkshop-350261890139-ap-south-1"
client=boto3.client('glue')


# Create Glue Crawler 
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
