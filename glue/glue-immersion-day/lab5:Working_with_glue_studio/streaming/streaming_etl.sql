########## Streaming ETL Job ########

# Define table for Kinesis
# Sample JSON Message
{ "uuid": "693038451", "Country": "Tuvalu", "ItemType": "Clothes", "SalesChannel": "Offline", 
"OrderPriority": "H", "OrderDate": "12/30/10", "Region": "Australia and Oceania", "ShipDate": "1/11/11",
"UnitsSold": "4333", "UnitPrice": "109.28", "UnitCost": "35.84", "TotalRevenue": "473510.24", 
"TotalCost": "155294.72", "TotalProfit": "318215.52" }

Glue Catalog > Add Table 
Table Name: lab5_kinesis
Database: examples_glueimmersion_db
Type of source : Kinesis 
Region: ap-south-1
Kinesis Stream Name: glueworkshop
Data Format: JSON 
Edit Schema as JSON 
[
  {
    "Name": "uuid",
    "Type": "string",
    "Comment": ""
  },
  {
    "Name": "country",
    "Type": "string",
    "Comment": ""
  },
  {
    "Name": "itemtype",
    "Type": "string",
    "Comment": ""
  },
  {
    "Name": "saleschannel",
    "Type": "string",
    "Comment": ""
  },
  {
    "Name": "orderpriority",
    "Type": "string",
    "Comment": ""
  },
  {
    "Name": "orderdate",
    "Type": "string",
    "Comment": ""
  },
  {
    "Name": "region",
    "Type": "string",
    "Comment": ""
  },
  {
    "Name": "shipdate",
    "Type": "string",
    "Comment": ""
  },
  {
    "Name": "unitssold",
    "Type": "string",
    "Comment": ""
  },
  {
    "Name": "unitprice",
    "Type": "string",
    "Comment": ""
  },
  {
    "Name": "unitcost",
    "Type": "string",
    "Comment": ""
  },
  {
    "Name": "totalrevenue",
    "Type": "string",
    "Comment": ""
  },
  {
    "Name": "totalcost",
    "Type": "string",
    "Comment": ""
  },
  {
    "Name": "totalprofit",
    "Type": "string",
    "Comment": ""
  }
]

SAVE 
Next Craete 