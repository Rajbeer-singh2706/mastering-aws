#Incremental Data Loads
#Add additional records in source table
mysql -h ${mysqlendpoint} -u glueworkshop -pImmersionsDay glueworkshop -e \
	"insert into orders values(100,'Jewels',44.00,'2022-02-01'); \
	insert into orders values(101,'Iphone',841.00,'2022-02-02'); \
	insert into orders values(102,'Toys',41.00,'2022-02-03'); \
	insert into orders values(103,'Dress',43.00,'2022-02-04'); \
	insert into orders values(104,'Headphone',24.00,'2022-02-05'); \
	insert into orders values(4,'Display Cable',20.00,'2022-01-06'); \
	update orders set price=14.45 where orderid=3"


#
mysql -h ${mysqlendpoint} -u glueworkshop -pImmersionsDay glueworkshop -e "select * from orders"


#
aws glue start-job-run \
    --job-name glueworkshop-lab10-etl-job 
    
# Different modes of re-processing data
Glue Bookmarks provide you with indepth control on re-processing the data files/data records for different 
situations

Reprocess job bookmark: This option can be used to only re-populate specific data from the past. An example 
could be, the source team notifies that the data records as of Day 1 and Day 2 of the current month were 
incorrect and they have corrected them. You now need to update that data in your data lake environment. 
We could pause the bookmark, delete the target files corresponding to those two days alone, and load data
for only those two days.

Rewind job bookmark - This option can be used to correct errors in the Glue ETL job. A typical situation 
could be, if a bug is identified in the Glue script that was used to process data for the past 1 week. 
We could rewind the bookmark a week before and delete the target files only for the past/current week 
and re-process the data with updated code.

Reset job Bookmark - This option can be used during job development and also in test environments where 
you want to process all the source data. Remember to delete the target data, before running the job as 
it could create duplicate entries.

Now, let's look at these job bookmarks options in more details

############## Reprocess specific files using Job Bookmark - ###############
Bookmarks provide you with the ability to reprocess data as of a specific timeframe and not rewind 
it entirely.

mysql -h ${mysqlendpoint} -u glueworkshop -pImmersionsDay glueworkshop -e \
    "insert into orders values(200,'Electronics',47.00,'2022-04-01'); \
    insert into orders values(201,'Baby monitor',345.00,'2022-04-02'); \
    insert into orders values(202,'Toys',75.00,'2022-04-03'); "

aws glue start-job-run \
    --job-name glueworkshop-lab10-etl-job 


# check athena table: orders_target

# Assume the team populating the RDS orders table found out that the second batch of records had been 
populated with incorrect dates. They should have their orderdate as of March-2022. They are now updating
mysql table to reflect that change and have notified the Glue team about that as well. Run below command 
in Cloud9 Terminal window to update required records in the orders table.

mysql -h ${mysqlendpoint} -u glueworkshop -pImmersionsDay glueworkshop -e \
    "update orders set orderdate='2022-03-01' where orderid=100;\
     update orders set orderdate='2022-03-02' where orderid=101;\
     update orders set orderdate='2022-03-03' where orderid=102;\
     update orders set orderdate='2022-03-04' where orderid=103;\
     update orders set orderdate='2022-03-05' where orderid=104;"

# mysql -h ${mysqlendpoint} -u glueworkshop -pImmersionsDay glueworkshop -e "select * from orders"

# Delete the target file from the 2nd run from S3 location (/output/lab10/orders).

# To change Glue job bookmark option from Enable to Pause, Go to the AWS Glue studio console , 
click Jobs on the left, select job glueworkshop-lab10-etl-job and Choose Job Details tab.

# Also, enter below Job parameters under Advanced properties section in Job Details tab.

--job-bookmark-from => Enter Jobid of 1st run(Bookmark reset to point in time when the job was completed.
So when running, all records processed from the subsequent runs will be loaded)

--job-bookmark-to => Enter jobid of 2nd/3rd(Job will load records until this run, including the records 
loaded in this job id)


#15. Save the changes by clicking on Save button at the top right corner of the job editor panel.
#16. Run the job again by clicking on `Run' button on the top right corner of the job editor panel.
#17. Once the job completes the run, you can verify that the file from only 2nd/3rd run was re-processed. 
The dates are updated to March as in the MySQL database, Also it didn't re-process the data from 1st run.

Verify the data in orders_target table using Athena.


####################### REWIND JOB BOOKMARK #################
Lets emulate a situation where the files that are being populated from 2nd/3rd run(Assume 1st run loaded 
all historical data) are huge and you would like to remove the coalesce statement an re-process the data 
from 2nd/3rd run onwards. So you have to rewind the job bookmark to process data from 2nd/3rd run.

Go to Script tab in the the job editor panel and comment the line of code with coalesce statement as below. 
postdf=SQTable_node1.toDF()
# postdf=postdf.coalece(1)
print("Porcessed records in this batch- ",postdf.count())
print("ID of records processed in this batch-")

#19. Go to Job details tab and enable bookmarks again and also remove the arguments for 
job-bookmark-from and job-bookmark-to parameters that we added in step 13 and 14.

#20. Save the changes by clicking on Save button at the top right corner of the job editor panel.

#21. Go to Runs tab, scroll down to the 1st job run and click Rewind Job Bookmark button . 
Click Rewind on the pop-up to rewind the bookmark. We must select the job with RunID that was 
last successfully completed. Glue will re-process data for all the subsequent runs.

################ Reset Job Bookmark #############
Let's consider a situation that we are not happy with the number of files that got created with 
rewinding the bookmark and would like to reprocess all data from the begining from orders table in 
MySQL RDS database.

On the Glue job editor panel, expend the Actions dropdown and click on Reset job Bookmarks as shown below.


#26. You should see a message that the bookmarks is successfully reset. Glue Reset
#27. Go to Script tab in the the job editor panel and uncomment the line of code with coalesce that we
commented is step 18.
#28. Save the changes by clicking on Save button at the top right corner of the job editor panel.
#29. Once you have reset the job bookmark, delete all target files from the S3 bucket location.
#30. Run the job again by clicking on Run button on the top right corner of the job editor panel.
#31. Once the job completes the run, we can verify the data in orders_target table using Athena and 
also new file S3 location.
# Athena query shows that orders_target table has 14 records. Job re-populated the missing record 
from 1st run as well

With resetting the job bookmarks, Glue job reporcessed all records from the source orders MySQL table and 
populated the target 
orders_target table with all records, including the records that were not processed earlier due to the 
incremental nature of job bookmarks.

You have successfully completed the Incremental Data Loads segment of the lab and demonstrated how you can selectively re-process specific data from source system, rewind and process all data after a specific job run, reset and re-populate the entire source data for different situations.

