import sys
from awsglue.transforms import *
from awsglue.utils import getResolvedOptions
from pyspark.context import SparkContext
from awsglue.context import GlueContext
from awsglue.job import Job

from pyspark.sql.functions import udf,col
from pyspark.sql.types import IntegerType, StringType
from pyspark.sql import SQLContext
from pyspark.context import SparkContext
from pyspark.sql import functions as F

from datetime import datetime

def get_country_code2(country_name):
    try:
        if country_name in COUNTRY_NAME_TO_COUNTRY_CODE:
            return COUNTRY_NAME_TO_COUNTRY_CODE[country_name]
    except:
        country_code2 = ''


udf_get_country_code2 = udf(lambda z: get_country_code2(z), StringType())

# Creating GlueContext
glueContext = GlueContext(SparkContext.getOrCreate())

# Creating Glue Dynamic Frame
dynaFrame = glueContext.create_dynamic_frame.from_catalog(database="database101", table_name="csv")
# Converting Glue Dynamic Frame to Spark Data Frame
dataframe = dynaFrame.toDF()
dataframe.printSchema()
# Renaming Columns as it has extra space so replacing space with _
renamed_df = dataframe.select([F.col(col).alias(col.replace(' ', '_')) for col in dataframe.columns])
renamed_df.printSchema()
# Adding country code column and getting the code from the UDF and function created
# Filtering on AUstraling and writing back as parquet
new_df = renamed_df.withColumn('country_code_2', udf_get_country_code2(col("country")))
new_df_aus = new_df.filter("country == 'Australia'").limit(10)
new_df_aus.write.mode('overwrite').parquet("s3://glue-testing-etl-targets/gluejob1")


COUNTRY_NAME_TO_COUNTRY_CODE = {
    'Abkhazia': 'AB',
    'Afghanistan': 'AF',
    'Albania': 'AL',
    'Algeria': 'DZ',
    'American Samoa': 'AS',
    'Andorra': 'AD',
    'Angola': 'AO',
    'Anguilla': 'AI',
    'Antigua and Barbuda': 'AG',
    'Argentina': 'AR',
    'Armenia': 'AM',
    'Aruba': 'AW',
    'Australia': 'AU',
    'Austria': 'AT',
    'Azerbaijan': 'AZ',
    'Bahamas': 'BS',
    'Bahrain': 'BH',
    'Bangladesh': 'BD',
    'Barbados': 'BB',
    'Belarus': 'BY',
    'Belgium': 'BE',
    'Belize': 'BZ',
    'Benin': 'BJ',
    'Bermuda': 'BM',
    'Bhutan': 'BT',
    'Bolivia': 'BO',
    'Bonaire': 'BQ',
    'Bosnia and Herzegovina': 'BA',
    'Botswana': 'BW',
    'Bouvet Island': 'BV',
    'Brazil': 'BR',
    'British Indian Ocean Territory': 'IO',
    'British Virgin Islands': 'VG',
    'Virgin Islands, British': 'VG',
    'Brunei': 'BN',
    'Brunei Darussalam': 'BN',
    'Bulgaria': 'BG',
    'Burkina Faso': 'BF',
    'Burundi': 'BI',
    'Cambodia': 'KH',
    'Cameroon': 'CM',
    'Canada': 'CA'}
