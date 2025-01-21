############# Steps Functions ###########

###### Building Step Function Workflow #####
# 1. Click States Machine, then click Create States Machine.
# 2. Choose Design your workflow visually and choose Type as Standard.

# 3. In Design workflow, click Flow tab on the left, 
drag and drop Parallel state into the dotted box in the design canvas.

# 4. Click Action tab on the left, type Glue in the search box, drag and drop 
 - AWS Glue - StartJobRun state into the dotted box on the left branch in Parallel state.
 - Under Configuration tab on the right
    * State name: case data extract
    * In API Parameters, set JobName: lab7-covid-case-count-data-extract
    In Next state, choose Add new state
    Check the checkbox next to Wait for task to complete - optional

#5. Drag and drop AWS Glue - StartJobRun state into the dotted box under the case data 
extract state in the design canvas.
    State name : case data process
    JobName: lab7-covid-case-count-data-process
    Next state: choose Add new state
    Check the checkbox next to Wait for task to complete - optional

#6.Type Glue crawler in the search box, drag and drop 
AWS Glue - StartCrawler state into the dotted box under the case data process state in the 
design canvas.
    Set State name: crawl case data
    Name: lab7-covid-case-count-processed-crawler
    In Next state, choose Go to end

#7. Type Glue in the search box, drag and drop 
AWS Glue - StartJobRun state into the dotted box on the right branch in Parallel state.
    Set State name : vaccine data extract
    In API Parameters, set JobName to lab7-vaccine-count-data-extract in JSON
    In Next state, choose Add new state
    Check the checkbox next to Wait for task to complete - optional

#8. Drag and drop AWS Glue - StartJobRun state into the dotted box under the vaccine data 
extract state in the design canvas.
    State name:  vaccine data process
    JobName :  lab7-vaccine-count-data-process
    Next state: Add new state
    Check the checkbox next to Wait for task to complete - optional

#9. Type Glue crawler in the search box, drag and drop 
AWS Glue - StartCrawler state into the dotted  box under the vaccine data process state in the 
design canvas.
    Set State name value to crawl vaccine data
    In API Parameters, set Name to lab7-vaccine-case-count-processed-crawler in JSON
    In Next state, choose Go to end

#10. We create 2 parallel data process inside the Parallel state box like the following.

#11. Click the Parallel state box in design canvas,
    Next state: Add new state
    Error handling tab=> Catch errors => Add new catcher => choose States.ALL
    Fallback state => Add new state

#12. Click Action tab on the left, type SNS in the search box, drag and drop
Amazon SNS - Publish state into the dotted box below the catch flow under the Parallel state box.
    Set State name: Notify failure
    In API Parameters, in Topic dropdown 
      select arn:aws:sns:<region>:<account#>:lab8-sns-failure-notification
    Next state, choose Add new state

#13. On the left side, clear the search box and click Flow, drag and drop Fail state box 
into the dotted box under Notify failure in design canvas.

#14.Click Action tab on the left, type SNS in the search box, drag and drop 
    Amazon SNS - Publish state into the empty dotted box below the Parallel state box.
    Set State name : Notify success
    In API Parameters, in Topic dropdown
     arn:aws:sns:<region>:<account#>:lab8-sns-success-notification
    Next state => Add new state

#15. On the left side, clear the search box and click Flow, drag and drop Success state box 
into the dotted box under Notify success in design canvas.

#16. We are done creating the workflow by now. Click Next on top right corner to go to the next step. 
We will be able to review the generated code. Click Next on the bottom to go to next step

#17. Set the state machine settings as the following and click Create state machine in the bottom.
Under Name, set State machine name to COVID-19-workflow
Under Permissions, select Choose an existing role, under Exisiting roles select
AWSStepFunctionRole-glueworkshop

#18.Once the new state machine is created successfully, click Start execution, and click Start execution 
with all the default settings.

#19.Once the execution of state machine finishes, you should be able see the state machine ends up in 
Success state.

#20. Next, we will add a mocked failure in the workflow and see how the Step Function state machine 
handles it. Click Edit state machine button, in the next screen click Workflow studio to go back 
to the design canvas. 
    Type Glue in the search box, drag and drop AWS Glue - StartJobRun state into Parallel state.
    State name: Raise error
    Name to lab7-raise-error
    Next state=> Go to end
    Check the checkbox next to Wait for task to complete - optional

#21. Click Apply and exit on the top right corner, and click Save and then Save anyway. 
Then click Start execution and Start execution again with default settings. The state machine ends up in
Fail state because one of the job executions failed.

#22. Click Edit state machine button, in the next screen click Workflow studio to go back to the 
design canvas. Delete Raise error state from the state machine so it will finish successfully.
