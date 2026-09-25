drop table silver.crm_prd_info
Create TABLE silver.crm_prd_info(
prd_id INT,
cat_id NVARCHAR(50),
prd_key NVARCHAR(50),
prd_nm NVARCHAR (50),
prd_cost INT,
prd_line NVARCHAR(50),
prd_start_dt DATETIME,
prd_end_dt DATETIME,
dwh_create_date DATETIME2 DEFAULT GETDATE()
)

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
