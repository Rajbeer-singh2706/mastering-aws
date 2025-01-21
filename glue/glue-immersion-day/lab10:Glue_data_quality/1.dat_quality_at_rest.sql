# Validate Glue Data Catalog

#1. From the navigation pane on the left, click Data Catalog and select Tables.
#2. Based on the activities you performed in Lab 1, you should be able to see console_* list of tables.

# Generate recommended ruleset
#3. Select console_json table and navigate to Data quality tab. Under Rulesets click on Recommend rules
#4. Provide Ruleset name as covid-data-catalog. For IAM Role, select the role with -glueworkshop. 
Then click on Recommend ruleset

#5. You will see a task with Running status under Recommendation task runs. You will see the Run status 
changing to Completed in approximately 2 mins.

#6. Once the Recommendation task run is complete, you can click the Refresh button to see the new 
Ruleset created.

#7. AWS Glue has created a Ruleset based on the sampling done for the Glue Data Catalog table / dataset 
that was selected. You can view the Rules by selecting the new Ruleset that we just created. Under 
Actions you will be able see the options to Edit or Delete the Ruleset.

# Evaluate Data quality using ruleset
#8. Next, we will use the Evaluate ruleset option to evaluate the Data quality of the data set.

#9.In the Evaluate data quality page, select the IAM Role with -glueworkshop and click Evaluate ruleset.

# You will be able to see a Daa quality task run with Run status as Running.
#In a few mins, you will see that the ececution is completed. You will be able to see that all the 49 checks have passed.

# Edit ruleset and reevaluate data quality
# Now let us edit some rules in the Ruleset and see how the report will look like. Let us navigate to 
AWS Glue --> Tables --> console_json --> covid-data-catalog. Once you are in the covid-data-catalog 
ruleset, under Actions, select Edit.

#After making the edits, click Update ruleset. Click on Evaluate ruleset, select IAM role as *-glueworkshop and click Evaluate ruleset.
# 11. Now you will be able to see that two checks have failed.

# Let us find the detailes by clicking View details option. There you will be able to see the details on the rules that were failed.

