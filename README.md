# Ecommerce-Operation-Analysis
Process Load Analysis, Inbound and Outbound Load Analysis and Overall Process MIS Report. Data was extracted from Excel files and compiled into SQL. SQL queries are used to take accurate readings and exploratory Data analysis. Data visualisation is done in Power BI for visual analysis and meeting reports

 ## 1. Primary Data Extraction using Excel VBA
    
 Data needed to be extracted from reports which were created by other departments. These were not in tabular form and each sheet was created for each date. Doing copy-paste is tedious work, so the below Excel module was created. With this, if data had been in the same cell throughout all sheets, we could extract all data in one go
 After data extraction 2 excel files were created for SQL
   1. MH_Daily_Process ( Not all data was available only sample )
   2. Truckload arrival details (Not all data was available only a sample )

## 2. Data Extraction from Excel sheets to MS-SQL

  Now from sheets in Excel, data is extracted and inserted into a master file for reporting and data analysis
  Monthly updated files are imported into SQL Server, then created tables for this format.
  The stored procedure is created for executing the insertion of the data

## 3. Creating PowerBI Report

  1. Imported data from the Database
  2. Key Metrics were created using DAX Functions
  3. In the data Visualization tab, 3 pages were created :
     1. Weekly/Monthly/Yearly Report - reduce time for report by 50 %
     2. Process Analysis - For checking variance in load, Adequate Manpower, IRT issues etc
     3. IB-OB Analysis - Impacted shipment due to delay in truckload, CPD Breaches, Special run deployed and cut-off extension etc.

## 4. SQL Analysis ( Few Samples )

1. Process details category wise in a monthly basis
2. Highest IPP with manpower and process details
3. Details of IPP and Manpower required to process highest overall or resort or market or returns
4. MIS REPORT in view which can be viewed in monthly basis ( group by ) or daily basis
5. Can check for how many day shipments per bag (SPB) crossed above or below the limit. The same can be done for incoming also
 
 
