# Event Driven Workflows: Amazon EventBridge

# Event driven workflows
aws events put-rule \
    --name "glueworkshop-rule" \
    --event-pattern "{ \
                        \"source\": [\"aws.s3\"], \
                        \"detail-type\": [\"AWS API Call via CloudTrail\"], \
                        \"detail\": { \
                            \"eventSource\": [\"s3.amazonaws.com\"], \
                            \"eventName\": [\"PutObject\"], \
                            \"requestParameters\": { \
                                \"bucketName\": [\"${BUCKET_NAME}\"], \
                                \"key\": [{\"prefix\": \"input/lab8/eventdriven/\"}]
                            } \
                        } \
                    }"

#2. Next, we will create a new Glue workflow with starting trigger type of Event Engine.
aws glue create-workflow --name glueworkshop-event-driven

aws glue create-trigger \
    --workflow-name glueworkshop-event-driven \
    --type EVENT \
    --name s3-object-trigger \
    --actions JobName=lab8-covid-case-count-data-process

#3. Next, we will add the new Glue workflow and Step Function state machine created earlier as the targets to the EventBridge rule glueworkshop-rule. Run the following command in Cloud9 terminal.
aws events put-targets \
    --rule glueworkshop-rule \
    --targets "Id"="glueworkflow","Arn"="arn:aws:glue:${AWS_REGION}:${AWS_ACCOUNT_ID}:workflow/glueworkshop-event-driven","RoleArn"="arn:aws:iam::${AWS_ACCOUNT_ID}:role/AWSEventBridgeInvokeRole-glueworkshop" \
    --region ${AWS_REGION}

aws events put-targets \
    --rule glueworkshop-rule \
    --targets "Id"="stepfunction","Arn"="arn:aws:states:${AWS_REGION}:${AWS_ACCOUNT_ID}:stateMachine:COVID-19-workflow","RoleArn"="arn:aws:iam::${AWS_ACCOUNT_ID}:role/AWSEventBridgeInvokeRole-glueworkshop" \
    --region ${AWS_REGION}
    
#4. Go to the Amazon EventBridge Console , click Rules on the left, click on 
glueworkshop-rule and you will see the details of the rule. Scroll down and you should see 2 targets, 
one with type Glue Worksflow and one with type Step Functions state machine. Everytime this rule 
receives a matching event, it will trigger the targets.

#5. Next, we will copy a file to the S3 folder the event rule monitors and trigger an event to 
start the workflow. Run the following command in Cloud9 terminal. This will trigger an event through 
Event rule glueworkshop-rule, and in turn will trigger the 2 targets of the rule.
aws s3 cp ~/environment/glue-workshop/data/lab1/csv/sample.csv s3://${BUCKET_NAME}/input/lab8/eventdriven/

#6. Go to the AWS Glue console , click Workflows on the left. You should see the workflow 
glueworkshop-event-driven in Running status.

#7. Go to AWS Step Function console . In the navigation pane on the left, click States Machine,
click COVID-19-workflow and you should see it is in Running status.
