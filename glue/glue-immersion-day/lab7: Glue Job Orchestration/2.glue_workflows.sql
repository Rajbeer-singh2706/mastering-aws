#### Glue Workflows ####

# 1.AWS Glue Workflows 
 - Name: COVID-19-workflow
 - Create Workflow 
 
# Click Add trigger, click Add new tab and set the new trigger with following settings,
Set Name.    : start workflow
Trigger type : Schedule
Frequency.   : Hourly

# 
Click start workflow node to highlight it, click the Action dropdown, 
click Add jobs/crawlers to trigger, click Jobs tab, 
select 
 * lab7-covid-case-count-data-extract 
 * lab7-vaccine-count-data-extract 
Click Add.
 
#
Click 
lab7-covid-case-count-data-extract node and a new 
Add trigger dotted diamond node will show up. 
Click Add trigger node and set the trigger with following settings, and click Add.
Name.         : case extract done
Trigger type  : Event
Trigger logic : Start after ALL watched event

#
Click case extract done trigger, click the Action dropdown, 
click Add jobs/crawlers to trigger, click Jobs tab, 
 * lab7-covid-case-count-data-process 
click Add.


# Add Trigger 
Click lab7-covid-case-count-data-process node 
and a new Add trigger will show up. 
Click Add trigger node and set the trigger with following settings, and click Add.
Name.         : case process done
Trigger type : Event
Trigger logic: Start after ALL watched event

# Add both the Crawlers now
Click case process done trigger, click the Action dropdown
click Add jobs/crawlers to trigger, click Crawlers tab
 - lab7-covid-case-count-processed-crawler
 - lab7-vaccine-case-count-processed-crawler 

in the list, click Add.

#
Click lab7-vaccine-count-data-extract node and 
a new Add trigger will show up. 
Click Add trigger and set the trigger with following settings,
and click Add.
Name.        : vaccine extract done
Trigger type : Event
Trigger logic: Start after ALL watched event

#
Click vaccine extract done trigger, click the Action dropdown and 
click Add jobs/crawlers to trigger, click Jobs tab, 
 - lab7-vaccine-count-data-process
click Add.

#
Click case process done trigger, 
click the Action dropdown and click Add jobs/crawlers to watch, click Jobs tab, 
select 
  * lab7-vaccine-count-data-process in the list, 
click Add. case process done trigger 
now will watch the event from both jobs.

# We are now finished creating the workflow. Click Run Workflow on 
the top-right corner of the screen.


#Click the History tab in the bottom and you should see one running workflow. 
Click the radio button next to the Run ID and click View run details. 
You should see the status of the current run. Once the workflow finishes, 
you should see the status of all nodes turn green


#
Next, we will add a mock failed job into the workflow and see what happens. 
Go back to COVID-19-workflow design canvas, click start workflow node to highlight it, 
click the Action dropdown and 
 - click Add jobs/crawlers to trigger, click Jobs tab, 
 - lab7-raise-error in the list
 - click Add.

#
Click case process done trigger, click the Action dropdown and 
 - click Add jobs/crawlers to watch
 - click Jobs tab, 
 -  lab7-raise-error in the list, 
click Add.

# 
Click Run Workflow on the top-right corner of the screen. 
Go to History tab, click on the latest Run ID and click View run details. 
You should see workflow stops at case process done trigger 
because lab7-raise-error failed.

# 
(Optional) You can add or modify Glue job parameters for jobs in the workflow. 
Open the workflow design canvas and click 
  * lab7-vaccine-count-data-extract node, 
  
 - click Action dropdown and click Edit job parameters. 
 - Click Add parameter and add new parameter for the job. 
 - Once you are done adding new parameters, 
click Update.