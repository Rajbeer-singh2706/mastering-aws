URL: https://catalog.us-east-1.prod.workshops.aws/workshops/aaaabcab-5e1e-4bff-b604-781a804763e1/en-US/intro

######### Glue Database: examples_glueworkshop_db #############


# Create S3 Bucket and Clone Files

BUCKET_NAME=s3://glueworkshop-raj-14072023
aws s3 mb s3://${BUCKET_NAME}
aws s3api put-public-access-block --bucket ${BUCKET_NAME} \
  --public-access-block-configuration "BlockPublicAcls=true,IgnorePublicAcls=true,BlockPublicPolicy=true,RestrictPublicBuckets=true"
echo ${BUCKET_NAME}


cd ~/environment
curl 'https://static.us-east-1.prod.workshops.aws/public/245f2f9b-0cbe-4745-b2b1-1a07446a8515/static/download/glue-workshop.zip' --output glue-workshop.zip
unzip glue-workshop.zip
mkdir ~/environment/glue-workshop/library
mkdir ~/environment/glue-workshop/output

git clone https://github.com/jefftune/pycountry-convert.git
cd ~/environment/pycountry-convert
zip -r pycountry_convert.zip pycountry_convert/
mv ~/environment/pycountry-convert/pycountry_convert.zip ~/environment/glue-workshop/library/

cd ~/environment/glue-workshop
aws s3 cp --recursive ~/environment/glue-workshop/code/ s3://${BUCKET_NAME}/script/
aws s3 cp --recursive ~/environment/glue-workshop/data/ s3://${BUCKET_NAME}/input/
aws s3 cp --recursive ~/environment/glue-workshop/library/ s3://${BUCKET_NAME}/library/
aws s3 cp --recursive s3://covid19-lake/rearc-covid-19-testing-data/json/states_daily/ s3://${BUCKET_NAME}/input/lab5/json/



############ Deploy CloudFormation Template ############
aws cloudformation create-stack --stack-name glueworkshop \
            --template-body file://~/environment/glue-workshop/cloudformation/NoVPC.yaml \
            --capabilities CAPABILITY_NAMED_IAM \
            --region us-east-2 \
            --parameters \
            ParameterKey=UniquePostfix,ParameterValue=glueworkshop \
            ParameterKey=S3Bucket,ParameterValue=s3://${BUCKET_NAME}/

########################


git add .
git commit -m "Update Lab"
git push
############################