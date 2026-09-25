---------------------Check for duplicates or nulls based on cst_id--------------------

SELECT 
cst_id,
count(*) as coun
FROM bronze.crm_cust_info
GROUP BY cst_id
having count(*) > 1 or cst_id = NULL

----------------------clearing duplicates and NULL-----------------------------------------------

select *
from(
select *,
Row_number() over (partition by cst_id order by cst_create_date desc) as rank
from bronze.crm_cust_info
where cst_id is not null) t
where rank = 1

----------------------------Checking for extra unwanted spaces in firstname,lastname,gender and marital_status---------------
--------------IDEALLY : NO RESULT ----------------------------------------------------------------
SELECT cst_firstname
FROM bronze.crm_cust_info
WHERE cst_firstname != TRIM(cst_firstname)

SELECT cst_lastname
FROM bronze.crm_cust_info
WHERE cst_lastname != TRIM(cst_lastname)

SELECT cst_gndr
FROM bronze.crm_cust_info
WHERE cst_gndr != TRIM(cst_gndr)

SELECT cst_marital_status
FROM bronze.crm_cust_info
WHERE cst_marital_status != TRIM(cst_marital_status)

--------------------Checking data consistency------------------------------------------
SELECT DISTINCT cst_gndr
FROM bronze.crm_cust_info

SELECT DISTINCT cst_marital_status
FROM bronze.crm_cust_info


