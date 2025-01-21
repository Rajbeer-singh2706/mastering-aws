

############ Lab2: Configure Glue Develpment environment ##########

# Option 1: Use Glue Studio Notebook
 - create glue job notebook 
 Name: lab2-glueworksho-jupyter-notebook
 ROle: AWSGlueServiceRole-glueworkshop
 
 
 Note


%idle_timeout 30 
%number_of_workers 2 
%extra_py_files "s3://glueworkshop-raj-14072023/library/pycountry_convert.zip" 


Create a Inline Policy from UI 
------------------------------
{
	"Version": "2012-10-17",
	"Statement": [
		{
			"Sid": "VisualEditor0",
			"Effect": "Allow",
			"Action": "iam:PassRole",
			"Resource": "*"
		}
	]
}

Run the following command to retrieve the identity of the caller

aws sts get-caller-identity --profile workshop_is



Lab2 _ doc s
================
%idle_timeout 30 
%glue_version 3.0
%worker_type G.1X
%number_of_workers 2 
%extra_py_files "s3://glueworkshop-raj-14072023/library/pycountry_convert.zip"

%status
%stop_session

%profile workshop_is
%%configure 
{
  "region": "<AWS_Region>",
  "idle_timeout": "15"
}

https://github.com/jefftune/pycountry-convert