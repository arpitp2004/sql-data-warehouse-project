CREATE OR ALTER PROCEDURE silver.load_silver AS
BEGIN
	-------------------------------INSERTING INTO 1ST CRM TABLE-------------------------------------------------
	TRUNCATE TABLE silver.crm_cust_info
	INSERT INTO silver.crm_cust_info(
	cst_id,
	cst_key,
	cst_firstname,
	cst_lastname,
	cst_marital_status,
	cst_gndr,
	cst_create_date
	)

	SELECT cst_id,
	TRIM(cst_key) as cst_key,
	TRIM(cst_firstname) as cst_firstname,
	TRIM(cst_lastname) as cst_lastname,
	CASE WHEN UPPER(TRIM(cst_marital_status)) = 'S' THEN 'SINGLE'
		 WHEN UPPER(TRIM(cst_marital_status)) = 'M' THEN 'MARRIED'
			 ELSE 'UNKNOWN'
	END as cst_marital_status,
	CASE WHEN UPPER(TRIM(cst_gndr)) = 'F' THEN 'FEMALE'
	   WHEN UPPER(TRIM(cst_gndr)) = 'M' THEN 'MALE'
			 ELSE 'UNKNOWN'
	END as cst_gndr,
	cst_create_date

	FROM(
	select *
	from(
	select *,
	Row_number() over (partition by cst_id order by cst_create_date desc) as rank
	from bronze.crm_cust_info
	where cst_id is not null) t
	) as t
	where rank = 1
	----------------------------------------INSERT INTO 2ND CRM TABLE------------------------------------------------
	TRUNCATE TABLE silver.crm_prd_info;
	INSERT INTO silver.crm_prd_info(
	prd_id ,
	cat_id ,
	prd_key ,
	prd_nm ,
	prd_cost ,
	prd_line ,
	prd_start_dt ,
	prd_end_dt 
	)



	SELECT prd_id,
	replace(substring(prd_key,1,5),'-','_') as cat_id,
	substring(prd_key,7,len(prd_key)) as prd_key,
	prd_nm,
	ISNULL(prd_cost,0) as prd_cost,
	CASE WHEN UPPER(TRIM(prd_line)) = 'R' THEN 'ROAD'
		 WHEN UPPER(TRIM(prd_line)) = 'M' THEN 'MOUNTAINS'
		 WHEN UPPER(TRIM(prd_line)) = 'S' THEN 'OTHER SALES'
		 WHEN UPPER(TRIM(prd_line)) = 'T' THEN 'TOURING'
		 ELSE 'N/A'
	END as prd_line,
	CAST(prd_start_dt as date)as prd_start_dt,
	cast(LEAD (prd_start_dt) over (partition by prd_key order by prd_start_dt)-1 as date) as prd_end_dt
	FROM bronze.crm_prd_info
	----------------------------------INSERT INTO 3RD CRM TABLE---------------------------------------------------------
	TRUNCATE TABLE silver.crm_sales_details;
	INSERT INTO silver.crm_sales_details(
	sls_ord_num ,
	sls_prd_key ,
	sls_cust_id ,
	sls_order_dt,
	sls_ship_dt ,
	sls_due_dt ,
	sls_sales ,
	sls_quantity ,
	sls_price
	)

	select 
	sls_ord_num,
	sls_prd_key,
	sls_cust_id,
	CASE WHEN sls_order_dt  = 0 or len(sls_order_dt) != 8 then null
		 else CAST(CAST(sls_order_dt AS VARCHAR) AS DATE)
	END AS sls_order_dt,
	CASE WHEN sls_ship_dt  = 0 or len(sls_ship_dt) != 8 then null
		 else CAST(CAST(sls_ship_dt AS VARCHAR) AS DATE)
	END AS sls_ship_dt,
	CASE WHEN sls_due_dt  = 0 or len(sls_due_dt) != 8 then null
		 else CAST(CAST(sls_due_dt AS VARCHAR) AS DATE)
	END AS sls_due_dt,
	CASE WHEN sls_sales <=0 or sls_sales is null or sls_sales != sls_quantity * abs(sls_price)
		 THEN sls_quantity * abs(sls_price)
		 ELSE sls_sales
	END as sls_sales,
	sls_quantity,
	CASE WHEN sls_price is null or sls_price <=0
		 THEN sls_sales/NULLIF(sls_quantity,0)
		 ELSE sls_price
	END AS sls_price
	FROM bronze.crm_sales_datails


	----------------------------------INSERTING THE 1ST ERP TABLE----------------------------------------------------
	TRUNCATE TABLE silver.erp_cust_az12;
	INSERT INTO silver.erp_cust_az12(cid,bdate,gen) 
	SELECT
	CASE WHEN CID LIKE 'NAS%' THEN SUBSTRING(CID,4,LEN(CID))
		 ELSE CID
	 END AS CID,
	 CASE WHEN BDATE > GETDATE() THEN  NULL
		  ELSE BDATE
	 END AS BDATE,
	 CASE WHEN UPPER(TRIM(GEN)) IN ('F','FEMALE') THEN 'Female'
		  WHEN UPPER(TRIM(GEN)) IN ('M','MALE') THEN 'Male'
		  ELSE 'n/a'
	END AS GEN
	FROM bronze.erp_cust_az12

	---------------------------INSERTING THE 2ND ERP TABLE------------------------------------------------------
	TRUNCATE TABLE silver.erp_loc_a101;
	INSERT INTO silver.erp_loc_a101(cid,cntry)

	SELECT
	REPLACE(CID,'-','') AS CID,
	CASE WHEN TRIM(CNTRY) = 'DE' THEN 'GERMANY'
		 WHEN TRIM(CNTRY) IN ('US','USA') THEN 'UNITED STATES'
		 WHEN TRIM(CNTRY) = 'UK' THEN 'UNITED KINGDOM'
		 WHEN TRIM(CNTRY) = '' OR CNTRY IS NULL THEN 'N/A'
		 ELSE CNTRY
	END AS CNTRY
	FROM bronze.erp_loc_a101

	----------------------------------INSERTING THE 3RD ERP TABLE------------------------------------------------
	TRUNCATE TABLE bronze.erp_px_cat_g1v2;
	INSERT INTO silver.erp_px_cat_g1v2(id,cat,subcat,maintenance)
	SELECT *
	FROM bronze.erp_px_cat_g1v2;
END
