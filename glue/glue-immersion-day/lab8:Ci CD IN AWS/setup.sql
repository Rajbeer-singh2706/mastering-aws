################ CI / CD #######################
1. AWS CodePipeline 
2. AWS CodeCommit 
3. AWS CodeBuild 
4. AWs CloudFormation

#Deploy the CloudFormation Template

aws cloudformation create-stack \
            --stack-name glueworkshop-cicd \
            --template-body file://~/environment/glue-immersion-day/lab9/script/glue-cicd.yml \
            --capabilities CAPABILITY_NAMED_IAM \
            --parameters ParameterKey=S3Bucket,ParameterValue=glueworkshop-350261890139-ap-south-1


aws cloudformation create-stack \
            --stack-name glueworkshop-cicd \
            --template-body file://~/environment/glue-workshop/code/lab9/glue-cicd.yml \
            --capabilities CAPABILITY_NAMED_IAM \
            --parameters ParameterKey=S3Bucket,ParameterValue=${BUCKET_NAME}
