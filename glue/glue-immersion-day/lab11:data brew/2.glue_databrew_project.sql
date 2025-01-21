#Glue DataBrew Project

We will create a DataBrew project and a recipe to transform the dataset we created earlier.

#1. Click PROJECTS on the left.
#2. Click Create project.
#3. Under Project details set Project name to covid-testing.
#4.Under Select a dataset choose My datasets then select the covid-testing dataset by clicking the radio button next to it.
#5. Under Permission select AWSGlueDataBrewServiceRole-glueworkshop for Role name from the dropdown list.
#6. Click Create project.

Once the project is created, you will have a work area with the sample data displayed in the data grid. You can also check the schema and profile of the data by clicking SCHEMA and PROFILE in the upper right-corner of the grid. On the right of the screen is the recipe work area.
Next, we are going to create a simple recipe using built-in transformations.

#7. You should see a Recipe work area to the right of the data grid. If not, click the RECIPES icon on the upper-right corner.
#8. Click the Add step button in the recipe work area. You will see a long list of transformations provided by DataBrew that you can use to build your recipe. You can take a look to see what transformations are provided.
#9. Click Delete in the COLUMN ACTIONS group. In the Source columns list select:
    dateChecked
    death
    deathIncrease
    fips
    hash
    hospitalized
    hospitalizedIncrease
    negative
    negativeIncrease
    pending
    positive
    total
    totalTestResults

#10. Click Apply. You'll see the selected columns are gone in the sample data grid as a result.
#11. Click the Add step icon on the upper-right corner of the recipe area, then the Add step configuration 
will show up again on the right.

#12. Select DATEFORMAT in DATE FUNCTION group, select Source column in Values using, select date in Source 
column, select yyyy-mm-dd in Data format, name destination column date_formatted, click Apply. A new string column with name date_formatted is added in the grid.

#13. Click the Add step icon, select Change type in COLUMN ACTION group, select date_formatted in Source 
column, select date in Change type to, then click Apply. Notice the datatype of column date_formatted 
changed from string to date.

#14. Click the Add step icon, select By Condition in FILTER group, select state in Source column, select 
Is exactly in Filter condition, de-select all states values, then choose NY and CA in the list and click 
Apply. Notice sample data in the grid now only contains data from those 2 states.

#15. Click Reorder steps icon on the upper-right corner of the recipe area next to Add step icon. A new 
pop-up box will show all steps of the current recipe. Move the Filter values by state from the 4th step
to the 2nd step then click Next. The validation will check the change. Once validation is finished, 
click Done. Notice in the recipe work area the order of the steps has changed.

#16. Click the Add step icon, select Delete in COLUMN ACTIONS group, select date in Source columns, click Apply.
#17. Click the Add step icon, select DIVIDE in MATH FUNCTION group, select Source columns in Values using. 
First check positiveIncrease and then totalTestResultsIncrease in Source columns. Set positiveRate as the 
name of Destination column then click Apply. A new double column with name positiveRate is added in the 
grid.

#18. Click the Add step icon, select MULTIPLY in MATH FUNCTION group, select Source column and value in Values using list, select positiverate in Source column, set Custom value to 100, set Destination column name to positivePercentage then click Apply. A new double column with name positivePercentage is added in the grid.
#19. Click the Add step icon, selete Delete in COLUMN ACTIONS group then in Source columns list select:

    positiveIncrease
    totalTestResultsIncrease
    positiveRate
    Click Apply.

#20. Click the Add step icon, select Pivot - rows to columns in PIVOT group. Select state in Pivot column list, select mean and positivePercentage in Pivot values, click Preview changes to see what the pivot table will look like then click Finish. A new table structure will be created based on the pivot operation with 2 new columns named state_CA_positivePercentage_mean and state_NY_positivePercentage_mean
#21. This is what the project work area looks like with the finished recipe.


