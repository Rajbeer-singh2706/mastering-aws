
# Glue Data Quality in ETL Pipeline

The following are the high-level steps that you will cover in this lab:

1. Create data quality rules        – Build a set of data quality rules using the DQDL builder by choosing built-in rulesets that you configure.
2. Configure a data quality job      – Define actions based on the data quality results and output options.
3. Save and run a job with data quality – Create and run a job. Saving the job will save the rule sets you created for the job.
4. Monitor and review the data quality results – Review the data quality results after the job run is complete. Optionally, schedule the job for a future date.

## Glue Data Quality with Glue Studio ETL Jobs

#1. Navigate to AWS Glue Studio Console. Click on the hamburger sign on the left pane and choose Jobs. 
Select the option Visual with a blank canvas and click on Create

#2. Rename the job to data-quality-etl-pipeline. Under Job Details Page, select IAM Role which is already created as part of Glue Immersion Day- AWSGlueServiceRole-glueworkshop. Change the Number of requested workers from 10 to 5 and Number of retries to 0. Keep everything else as default values. Click on Save and then navigate back to Visual tab.
#3. Select the covid-19 dataset by clicking on Source and selecting AWS Glue Data Catalog as the source. Within Data source properties- Data Catalog, for Database, choose console_glueworkshop and for table, choose console_json from the drop down menu.
#4. Next, we are going to perform data quality checks by specifying data quality rules. For this, click on Action and select Evaluate Data Quality transform from the drop down menu.
#5. For Evaluate Data Quality transform, on the right hands side, under Transform section, you will find a space to write the data quality rules. You can define the rules by using out of the box rule types or based on Schema. Let's begin with our first rule. The column values for death increase should be greater than zero. We will introduce this rule by clicking on RuleType and searching for rule named ColumnValues in the search bar, and then clicking on + sign to add this rule into our rule set.
The rule is ColumnValues "deathincrease" > 0
#6. The next rule we will add is to check the completeness of column pending. This value should not include Nulls. For this, we will click on Rule types and select IsComplete rule type by clicking on + sign to make sure this column has non-null values
The rule is IsComplete "pending"

#7. Next, we are going to check the Column length for the column State and make sure that value of the column fips falls in the array of strings that we provide. These rules are from the previous lab where you have generated rulesets in AWS Glue Data Catalog.
The rules are:

ColumnLength "state" = 2, ColumnValues "fips" in ["53", "25", "51", "12", "34", "31", "18", "09", "26", "56", "44", "36", "42", "48", "50", "55", "41", "06", "17", "04", "13", "37", "33", "15", "08", "45", "47", "39", "32", "35", "24", "11", "02", "27", "20", "54", "21", "10", "05", "19", "28", "01", "29", "30", "38", "49", "16", "46", "22", "40", "23", "69", "60", "72", "78", "66"]

#8. The complete ruleset should look something like this:
#9.Next, you can perform certain actions based on data quality results as success or fail, for this, select the checkbox for Publish results to Amazon CloudWatch under data quality actions. Furthermore, you can also choose to fail the job when the data quality check fails, either before or after loading the target data.
#10.For Data quality transform output, you can further specify to output the original input data when data quality issues are detected or data quality results- rules and their status (pass or failed). We will select Data Quality option as this is useful if you want to take a custom action based on data quality results. We will also provide an S3 bucket location to save the data quality output. For this, the S3 bucket has already been created as part of CloudFormation template named glue-data-quality-results-etl, so copy, paste and specify the S3 bucket location. You can also browse the S3 buckets and folders by clicking on Browse S3 option.
#11.Select the Target to store the target data. For this, by clicking on Transform Node- Evaluate Data Quality, click on Target and Select** Amazon S3**. Browse S3 bucket list and select glue-data-quality-etl-curated-data bucket.
#12.Click on Save option on the top right corner to save all the configuration and rulesets. Next, Click on Run and Navigate to Runs section to monitor the status of Job Run. The status will change to Running once the job starts.
#13.Notice that the Job has failed because the data quality checks have failed.
#14.Navigate to Data Quality tab and scroll down to observe the results of data quality checks. You will find that the data quality checks for deathincrease and pending has failed, because there exists bad data which has values in negative for deathincrease and null values for pending columns. Hence, the insights will not be accurate if the good quality data does not exists.
#15.Let's check out the CloudWatch metrics. For this, navigate to Runs section and under "CloudWatch logs", click on "All logs". This will take you to CloudWatch Management Console.
#15.On the left hand side navigation menu, under Metrics, click on All metrics. Select Glue Data Quality, then Evaluation Context, Job Name, then you will find two metrics- glue.data.quality.rules.passed and glue.data.quality.rules.failed for your glue job data-quality-etl-pipeline for transform node EvaluateDataQuality. Based on these metrics, you can set alarms to send notifications about data quality results.
#16.Navigate to Amazon S3 Management Console and select glue-data-quality-results-etl bucket. Notice that data quality results is partitioned by date. The following is the output of the JSON file. You can use this file output to build custom data quality visualization dashboards.
