
######## Working with AWS Glue Bookmarks ########
In this lab we will demonstrate the following AWS Glue job bookmark functionalities

1. Configuring job bookmarks for AWS Glue jobs with JDBC data sources.
2. One time and incremental data loads using job bookmarks.
3. Configuring job bookmarks for AWS Glue jobs with Amazon S3 data sources.


#### Create Source Table in MYSQL and insert Data ######
# setup mysql db in RDS 
# username/password : admin/admin1234


# Create database
mysql -h database-1.c3qvckkqjgvl.ap-south-1.rds.amazonaws.com -u admin -p -e "create database glueworkshop";

# Create table 
mysql -h database-1.c3qvckkqjgvl.ap-south-1.rds.amazonaws.com -u admin -p -e "create table glueworkshop.orders (
	   orderid INT NOT NULL,
	   item VARCHAR(1000) NOT NULL,
	   price DOUBLE(6,2) NOT NULL,
	   orderdate DATE,
	   PRIMARY KEY ( orderid )
	)"
;

# Insert Records 
mysql -h ${mysqlendpoint} -u ${username} -pImmersionsDay glueworkshop -e \
"insert into orders values(0,'Webcam',185.49,'2022-01-02'); \
insert into orders values(1,'Monitor',240.99,'2022-01-02'); \
insert into orders values(2,'Mouse',12.89,'2022-01-03'); \
insert into orders values(3,'KeyBoard',24.99,'2022-01-04'); \
insert into orders values(5,'HDMI Cable',4.45,'2022-01-06')"

# Select 
mysql -h ${mysqlendpoint} -u glueworkshop -padmin1234 glueworkshop -e "select * from orders"

# AddMysql Tbale to AWS GLue Data Catalog 
aws glue start-crawler \
    --name lab5-rds-crawler

lab5_rds_glueworkshop_orders
