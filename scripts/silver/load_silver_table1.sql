use DataWarehouse;

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
