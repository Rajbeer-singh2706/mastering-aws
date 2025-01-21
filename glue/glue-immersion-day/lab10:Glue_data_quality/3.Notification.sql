# Nofitications for Data Quality checks

#Setup notifications for Data Quality Check
#1. Navigate to Amazon CloudWatch. Select All Alarms from the left hand side menu. Then click on Create alarm
#2.Click on Select metric. Under Custom namespaces, you will be able to see Glue Data Quality. Select Glue Data Quality.
Then select CatalogId, Database, Ruleset, Table.
There you will be able to see a metric with the name glue.data.quality.rules.failed. 
We are going to set the Alarm for any failed execution of Glue Data Quality check. 
Select the glue.data.quality.rules.failed entry and click Select metric.
#3. In the Specify metric and conditions page, change the Statistic to Sum and Period to 1 minute.
 In the Conditions section, select the Threshold type as Static. Select Greater/Equal and define the threshold value as 1 as below.
Then click Next
#4. In the Configure actions page, select In alarm. For Send a notification to the following SNS topic, select Create new topic. Select a topic name of your choice (for eg: Glue_DQ_Failures). Provide email address to receive the notification. Then click Create topic. After the topic is created, click Next
#5. In the Add name and description page, provide Alarm name as DQ_Failure_Alarm. If 
required, you can provide Alarm decription. Click Next
#6. In the next page Preview and create, you can validate all the details and click Create alarm.
#7. To receive emails, you need to confirm to the subscription that you created above. 
You would have received an email with subject WS Notification - Subscription Confirmation from 
AWS Notifications. Please follow that link to confirm the subcription.
To validate, navigate to Amazon SNS --> Topics --> Glue_DQ_Failures. Then select the Subscription that 
we just created. You should be able to see
#8. Now we will re-run the DQ check by navigating to AWS Glue --> Tables --> console_json --> 
covid-data-catalog then click Evaluate ruleset. Select the IAM role as *-glueworkshop and click 
Evaluate ruleset.

#9. Once the task completes, you will be able to see that two of the DQ checks have failed and in a 
couple of minutes, you should be able to see an email in your inbox notifying about the DQ check failure.