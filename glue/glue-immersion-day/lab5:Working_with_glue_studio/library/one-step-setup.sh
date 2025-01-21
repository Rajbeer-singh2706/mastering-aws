#!/bin/sh

URL=$1


echo "
============================> THIS SCRIPT WILL TAKE FEW SECONDS TO COMPLETE - PLEASE WAIT! <==============================================================================
"

##SETTING UP ENVIROMENT VARIABLES
echo "
============================> SETTING UP ENVIROMENT VARIABLES <===========================================================================================================
"
AWS_ACCOUNT_ID=`aws sts get-caller-identity --query Account --output text`
AWS_REGION=`aws configure get region`
BUCKET_NAME=glueworkshop-${AWS_ACCOUNT_ID}-${AWS_REGION}
echo " "
echo "export BUCKET_NAME=\"${BUCKET_NAME}\"" >> /home/ec2-user/.bashrc
echo "export AWS_REGION=\"${AWS_REGION}\"" >> /home/ec2-user/.bashrc
echo "export AWS_ACCOUNT_ID=\"${AWS_ACCOUNT_ID}\"" >> /home/ec2-user/.bashrc

. ~/.bash_profile

## CREATING LOCAL CLOUD9 DIRECTORIES, DOWNLOADING CONTENT AND UPLOADING BACK TO S3 - THIS WILL TURN INTO S3 FOLDERS AND FILES
echo "============================> MAKING UP LOCAL DIRECTORIES <==============================================================================================================="

cd ~/environment
aws s3 cp s3://ee-assets-prod-us-east-1/modules/aa287fde7dd448ffac85ed7824e5c1f0/v8/download/glue-workshop.zip glue-workshop.zip > /dev/null
unzip glue-workshop.zip > /dev/null
mkdir ~/environment/glue-workshop/output > /dev/null


### CHECKING WHICH URLS TO BUILD
len=`echo $URL |awk '{print length}'`

if [ $len -lt 150 ]; then
### BUILDING SMALLER URL VERSION

var1=$(echo $URL | grep -oP "public/.*?/" | cut -c 8-43) 

echo "

Build-ID  = $var1

"

echo "============================> DOWNLOADING CONTENT INTO THE DIRECTORIES <==================================================================================================
# PYCOUNTRY LIBRARY: pycountry_convert.zip
$(curl -s 'https://static.us-east-1.prod.workshops.aws/public/'$var1'/static/download/howtostart/awseevnt/s3-and-local-file/pycountry_convert.zip' --output ~/environment/glue-workshop/library/pycountry_convert.zip)
==========================================================================================================================================================================
"

else
### BUILDING LONGER URL VERSION

#Build-ID
var1=$(echo $URL | grep -oP "s/.*?/" | cut -c 3-38) 

#Key Pair Id
prefix="Key-Pair-Id="

var2=$(echo $URL | grep -oP "Key-Pair-Id=.*?&")
var2=${var2#"$prefix"}
var2=$(echo $var2 | tr -d '&')

#Policy
prefix="Policy="
var3=$(echo $URL | grep -oP "Policy=.*?&")
var3=${var3#"$prefix"}
var3=$(echo $var3 | tr -d '&')

#Signature
prefix="Signature="
var4=$(echo $URL | grep -oP "Signature=.*")
var4=${var4#"$prefix"}


echo "

Build-ID  = $var1

"

## CREATING LOCAL CLOUD9 DIRECTORIES, DOWNLOADING CONTENT AND UPLOADING BACK TO S3 - THIS WILL TURN INTO S3 FOLDERS AND FILES
echo "============================> DOWNLOADING CONTENT INTO THE DIRECTORIES <==================================================================================================
# PYCOUNTRY LIBRARY: pycountry_convert.zip
$(curl -s 'https://static.us-east-1.prod.workshops.aws/'$var1'/static/download/howtostart/awseevnt/s3-and-local-file/pycountry_convert.zip?Key-Pair-Id='$var2'&Policy='$var3'&Signature='$var4'' --output ~/environment/glue-workshop/library/pycountry_convert.zip)
==========================================================================================================================================================================
"

fi

echo "============================> UPLOADING EVERYTHING TO S3 <================================================================================================================
$(cd ~/environment/glue-workshop)
$(aws s3 cp --recursive ~/environment/glue-workshop/code/ s3://${BUCKET_NAME}/script/)
$(aws s3 cp --recursive ~/environment/glue-workshop/data/ s3://${BUCKET_NAME}/input/)
$(aws s3 cp --recursive ~/environment/glue-workshop/library/ s3://${BUCKET_NAME}/library/)
$(aws s3 cp --recursive s3://covid19-lake/rearc-covid-19-testing-data/json/states_daily/ s3://${BUCKET_NAME}/input/lab5/json/)
==========================================================================================================================================================================
"

##SETTING UP REQUIRED SECURITY GROUPS INBOUND RULES 
echo "============================> SETTING UP INBOUND RULES <=================================================================================================================="
ref_sg=$(aws ec2 describe-security-groups --query 'SecurityGroups[?contains(GroupName, `aws-cloud9-glueworkshop`) == `true`].GroupId' --output text)
target_sg=$(aws ec2 describe-security-groups --query 'SecurityGroups[?contains(GroupName, `DefaultVPCSecurityGroup`) == `true`].GroupId' --output text)
aws ec2 authorize-security-group-ingress --group-id $target_sg --protocol -1 --source-group $ref_sg
echo "
==========================================================================================================================================================================
"


##UPDATING CLI TO SUPPORT LATEST APIS REQUIRED (CLOUD9 --managed-credentials-action USED BELOW)
echo "
============================> UPDATING AWS CLI <==========================================================================================================================
"
curl -s  "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip -o -qq awscliv2.zip
sudo ./aws/install --bin-dir /usr/local/bin --install-dir /usr/local/bin --update > /dev/null
echo "
==========================================================================================================================================================================
"

export PATH=$PATH:$HOME/.local/bin:$HOME/bin:/usr/local/bin:/usr/local/bin/aws > /dev/null
#echo $PATH

. ~/.bash_profile > /dev/null

#which aws
#aws --version


##INSTALLING REQUIRED LIBRARIES (BOTO3 & PSQL CLIENT)
echo "============================> INSTALLING BOTO3 <=========================================================================================================================="
sudo pip3 install boto3 --quiet
echo "=========================================================================================================================================================================="


##ASSOCIATING NEW INSTANCE PROFILE TO CLOUD9 EC2 INSTANCE AND VERYFING ASSOCIATION
inst_prof=$(aws ec2 describe-iam-instance-profile-associations --query 'IamInstanceProfileAssociations[?contains(InstanceId, `'$( curl -s  http://169.254.169.254/latest/meta-data//instance-id)'`) == `true`].AssociationId' --output text)

echo "============================> ASSOCIATING NEW INSTANCE PROFILE TO CLOUD9 EC2 INSTANCE <=============================================================================
$(if [ -z $inst_prof ]
then
    echo "    
    associating AWSEC2InstanceProfile-GlueWorkshop... ... ...    
    "
    aws ec2 associate-iam-instance-profile --iam-instance-profile Name=AWSEC2InstanceProfile-GlueWorkshop --instance-id $( curl -s  http://169.254.169.254/latest/meta-data//instance-id)
else
    echo "    
    replacing:" $inst_prof "by AWSEC2InstanceProfile-GlueWorkshop    
    "
    aws ec2 replace-iam-instance-profile-association --iam-instance-profile Name=AWSEC2InstanceProfile-GlueWorkshop --association-id $(aws ec2 describe-iam-instance-profile-associations --query 'IamInstanceProfileAssociations[?contains(InstanceId, `'$( curl -s  http://169.254.169.254/latest/meta-data//instance-id)'`) == `true`].AssociationId' --output text)

fi )

============================> VERYFYING ASSOCIATION <=====================================================================================================================
$(aws ec2 describe-iam-instance-profile-associations  --filters 'Name=instance-id,Values='$( curl -s  http://169.254.169.254/latest/meta-data//instance-id)'' --query 'IamInstanceProfileAssociations[*].IamInstanceProfile.Arn' --output text > /tmp/msg.txt)
$(cat /tmp/msg.txt)
==========================================================================================================================================================================
"

##DISABLING AUTOMATIC CREDENTIALS MANAGEMENT (RUNNING WITH LATEST CLI!!)
echo "============================> DISABLING AUTOMATIC CREDENTIALS MANAGEMENT <=============================================================================
$(/usr/local/bin/aws cloud9 update-environment --environment-id $C9_PID --managed-credentials-action DISABLE)
"


. ~/.bash_profile > /dev/null

credArn=$(aws sts get-caller-identity --query Arn | grep AWSEC2ServiceRole-etl-ttt-demo | grep -oP "/.*?/" | cut -c 2-26)

while [ "$credArn" != "AWSEC2ServiceRole-etl-ttt" ]
do
    sleep 1s
    credArn=$(aws sts get-caller-identity --query Arn | grep AWSEC2ServiceRole-etl-ttt-demo | grep -oP "/.*?/" | cut -c 2-26)
done

##VALIDANTING NEW CREDENTIALS
echo "==================> VALIDATING CREDENTIALS <====================
$(aws configure set region $AWS_REGION)
$(aws sts get-caller-identity --query Arn | grep AWSEC2ServiceRole-etl-ttt-demo -q && echo "=====================> [IAM role valid] <=======================" || echo "==================> [IAM role NOT valid] <====================")
================================================================
"



. ~/.bash_profile

echo "

|========================================================================================================================================================================|
|########################################################################################################################################################################|
|##################################################################### SETUP SUCCESSFULLY COMPLETED #####################################################################|
|########################################################################################################################################################################|
|========================================================================================================================================================================|



|------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
|                                                        -->  1. DIRECTORIES BUILT & CONTENT DOWNLOADED LOCALLY                                                          |
|-----------------|------------------------------------------------------------------------------------------------------------------------------------------------------|
|                 |                                                                                                                                                      |
|  .. SUCCESS ..  | ~/environment/glue-workshop/[cloudformation | code | data | library | output]                                                                        |
|                 |                                                                                                                                                      |
|-----------------|------------------------------------------------------------------------------------------------------------------------------------------------------|
|                 |                                      -->  2. CONTENT UPLOADED INTO RESPECTIVE S3 BUCKET PATHS                                                        |
|-----------------|------------------------------------------------------------------------------------------------------------------------------------------------------|
|                 |                                                                                                                                                      |
|  .. SUCCESS ..  | s3://$BUCKET_NAME/serverless-data-analytics/[input/ | library/ | script/ ]                                                    |
|                 |                                                                                                                                                      |
|-----------------|------------------------------------------------------------------------------------------------------------------------------------------------------|
|                 |                                      -->  3. AWS CLI, BOTO3 LIB, & PSQL CLIENT INSTALLED                                                             |
|-----------------|------------------------------------------------------------------------------------------------------------------------------------------------------|
|                 |                                                                                                                                                      |
| .. SUCCESS ..   | AWS CLI Version: $(aws --version)                                        |
| .. SUCCESS ..   | Boto3 Version: boto3==$(pip list |grep boto3 | awk '{print $2}')                                                                                                                        |
|                 |                                                                                                                                                      |
|-----------------|------------------------------------------------------------------------------------------------------------------------------------------------------|
|                 |                                      -->  4. NEW INSTANCE PROFILE ASSOCIATED                                                                         |
|-----------------|------------------------------------------------------------------------------------------------------------------------------------------------------|
|                 |                                                                                                                                                      |
|  .. SUCCESS ..  | $(cat /tmp/msg.txt)                                                                        |
|                 |                                                                                                                                                      |
|-----------------|------------------------------------------------------------------------------------------------------------------------------------------------------|
|                 |                                      -->  5. SECURITY GROUP INBOUD RULES SETUP                                                                       |
|-----------------|------------------------------------------------------------------------------------------------------------------------------------------------------|
|                 |                                                                                                                                                      |
|  .. SUCCESS ..  | Source SG: $ref_sg has been added to Target SG: $target_sg                                                                    |
|                 |                                                                                                                                                      |
|-----------------|------------------------------------------------------------------------------------------------------------------------------------------------------|



|========================================================================================================================================================================|
|########################################################################################################################################################################|
|#################################################################### ENVIRONMENT VARIABLES SET #########################################################################|
|########################################################################################################################################################################|
|========================================================================================================================================================================|
|                                                                                                                                                                        |
|########################################################################################################################################################################|
|                                                                                                                                                                        |
| Bucket Name: ${BUCKET_NAME}                                                                                                                       |
| AWS Region:  ${AWS_REGION}                                                                                                                                                 |
| AWS ACCOUNT ID: ${AWS_ACCOUNT_ID}                                                                                                                                           |
|                                                                                                                                                                        |
|########################################################################################################################################################################|
|========================================================================================================================================================================|
"