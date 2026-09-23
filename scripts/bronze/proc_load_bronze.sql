use DataWarehouse
GO
CREATE OR ALTER PROCEDURE bronze.load_bronze AS
BEGIN
PRINT '---------------------------------------------------------------------------------';
PRINT 'LOADING BRONZE LAYER';
PRINT '---------------------------------------------------------------------------------';

PRINT '---------------------------------------------------------------------------------';
PRINT 'LOADING CRM TABLES'
PRINT '---------------------------------------------------------------------------------';

PRINT '>>>>>>>>TRUNCATING bronze.crm_cust_info ';
TRUNCATE TABLE bronze.crm_cust_info;
PRINT '>>>>>>>>LOADING bronze.crm_cust_info';
BULK INSERT bronze.crm_cust_info
from "F:\sql_course\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_crm\cust_info.csv"
with(
firstrow = 2,
fieldterminator = ',',
Tablock
);

PRINT '>>>>>>>>TRUNCATING bronze.crm_prd_info ';
TRUNCATE TABLE bronze.crm_prd_info;
PRINT '>>>>>>>>LOADING bronze.crm_prd_info';
BULK INSERT bronze.crm_prd_info
from "F:\sql_course\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_crm\prd_info.csv"
with(
firstrow = 2,
fieldterminator = ',',
Tablock
);
 
PRINT '>>>>>>>>TRUNCATING bronze.crm_sales_datails ';
TRUNCATE TABLE bronze.crm_sales_datails;
PRINT '>>>>>>>>LOADING bronze.crm_sales_datails';
BULK INSERT bronze.crm_sales_datails
from "F:\sql_course\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_crm\sales_details.csv"
with(
firstrow = 2,
fieldterminator = ',',
Tablock
);

PRINT '>>>>>>>>TRUNCATING bronze.erp_cust_az12 ';
TRUNCATE TABLE bronze.erp_cust_az12;
PRINT '>>>>>>>>LOADING bronze.erp_cust_az12';
BULK INSERT bronze.erp_cust_az12
from "F:\sql_course\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_erp\CUST_AZ12.csv"
with(
firstrow = 2,
fieldterminator = ',',
Tablock
);

PRINT '>>>>>>>>TRUNCATING bronze.erp_loc_a101 ';
TRUNCATE TABLE bronze.erp_loc_a101;
PRINT '>>>>>>>>LOADING bronze.erp_loc_a101';
BULK INSERT bronze.erp_loc_a101
from "F:\sql_course\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_erp\LOC_A101.csv"
with(
firstrow = 2,
fieldterminator = ',',
Tablock
);

PRINT '>>>>>>>>TRUNCATING bronze.erp_px_cat_g1v2; ';
TRUNCATE TABLE bronze.erp_px_cat_g1v2;
PRINT '>>>>>>>>bronze.erp_px_cat_g1v2;';
BULK INSERT bronze.erp_px_cat_g1v2
from "F:\sql_course\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_erp\PX_CAT_G1V2.csv"
with(
firstrow = 2,
fieldterminator = ',',
Tablock
);
END

