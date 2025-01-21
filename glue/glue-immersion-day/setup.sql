######### Pre Setup ###########
-- glueworkshop-350261890139-ap-south-1

BUCKET_NAME=glueimmersion-workshop-14072023
aws s3 ls s3://covid19-lake/ --no-sign-request
aws s3 cp --recursive s3://covid19-lake/rearc-covid-19-testing-data/json/states_daily/ s3://${BUCKET_NAME}/input/lab5/json/


git config --global user.name "Spark aws"
git config --global user.email testsparkaws@gmail.com

After doing this, you may fix the identity used for this commit with:


python3 -m venv de-venv 
pip install boto3 



Need to learn 
 - CloudFromation -> Devops Course, Seperate COurse 
 - Code Pipeline, COmit, Deploy, BUild -> AWs Developer Course 
 - SAM, CDK => AWs Developer Course 
 -

** paraalley we will study these and then implement AWS GLUE CI/CD ,
but be strong in AWS GLUE..

