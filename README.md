# Ecommerce-Operation-Analysis
Process Load Analysis, Inbound and Outbound Load analysis and Overall Process MIS Report. Data extracted from excel files and compiled into SQL. SQL queries are used to take accurate reading. Data visualisation is done in Power BI for visual analysis and meetings

 ## 1. Primary Data Extraction using Excel VBA
    
 Data needed to be extracted from reports which were created by other departments. These were not in tabular form and each sheet was created for each date. Doing 
 copy paste is tedious work, so below excel module was created. With this if data had been in same cell throughout all sheet, we could extract all data in one go
 After data extraction 2 excel file created for SQL
   1. MH_Daily_Process ( At present not all data available only sample )
   2. Truckload arrival details ( At present not all data available only sample )

## 2. Data Extraction from excel sheets to MS-SQL

  Now from sheets in excel, data is extracted and inserted to master file for reporting and data analysis
  Monthly wise updated files are imported in SQL Server, then created tables for these format.
  The stored procedure is created for executing the insertion of the data
 
 
