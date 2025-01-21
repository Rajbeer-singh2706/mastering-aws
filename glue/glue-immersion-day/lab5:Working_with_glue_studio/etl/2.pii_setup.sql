######## PII ##########
* PII > Personal Identifiable Information 

JobName: glue-immersion-lab5-pii-job


########## Source ############
Source: S3
Name: pii-source-data
S3 location: s3://glueworkshop-350261890139-ap-south-1/input/lab5/pii/
Data Format: csv 
Click Infer schema

######### Transform ########
Transform: Detect Sensitive Data
* Find sensitive data in each row and then Select specific patterns. 
   - Credit Card
    - Email Address
    - Social Security Number (SSN)
* redact detected text 
  - Replacement text : XXXXX

This string will replace all detected values in the output dataset.

* select Create new next to the Selected patterns box. 
Pattern name: Valid U.S. Phone Number (not starting with 0 or 1)
Expression: ^[\+]?[(]?[2-9]{1}[0-9]{2}[)]?[-\s\.]?[0-9]{3}[-\s\.]?[0-9]{4,6}$.
Context words:
- phone
- telephone
- phone number
- telephone number

Lastly, select Create pattern.
Return to the Glue Studio Editor interface and select 
Browse under Selected patterns

Target 
=======
Click Target Amazon S3.
Format: JSON
Compression Type: None
S3 Target Location: s3://glueworkshop-350261890139-ap-south-1/output/lab5/pii/
Data Catalog update option: Create a table in the Data Catalog and on subsequent runs, 
update the schema and add new partitions
Database: examples_glueimmersion_db
table: lab5_redacted