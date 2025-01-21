##################### CLI ############

AWS_ACCOUNT_ID=`aws sts get-caller-identity --query Account --output text`
AWS_REGION=`aws configure get region`
BUCKET_NAME=glueworkshop-${AWS_ACCOUNT_ID}-${AWS_REGION}
echo "export BUCKET_NAME=\"${BUCKET_NAME}\"" >> /home/ec2-user/.bashrc
echo "export AWS_REGION=\"${AWS_REGION}\"" >> /home/ec2-user/.bashrc
echo "export AWS_ACCOUNT_ID=\"${AWS_ACCOUNT_ID}\"" >> /home/ec2-user/.bashrc
echo ${BUCKET_NAME}
echo ${AWS_REGION}
echo ${AWS_ACCOUNT_ID}

# create database 

aws glue create-database --database-input "{ \
    \"Name\": \"cli_glueworkshop\", 
    \"Description\": \"this database is created using AWS CLI \" \
    }"

#Create Crawlers
BUCKET_NAME=glueworkshop-350261890139-ap-south-1
aws glue create-crawler \
--name cli-lab1 \
--role AWSGlueServiceRole-glueworkshop \
--database-name cli_glueworkshop \
--table-prefix cli_ \
--targets "{\"S3Targets\": [{\"Path\": \"s3://${BUCKET_NAME}/input/lab1/csv\"}, \
                            {\"Path\": \"s3://${BUCKET_NAME}/input/lab5/json\"} ]}"

# Start Crawler 
aws glue start-crawler --name cli-lab1

