use DataWarehouse
go
create view gold.dim_customers as
select 
row_number() over(order by cst_id) as customer_key,
ci.cst_id,
ci.cst_key,
ci.cst_firstname,
ci.cst_lastname,
ci.cst_marital_status,
case when ci.cst_gndr!='n/a' then ci.cst_gndr
else coalesce(ca.gen,'n/a')
end as gender,
ci.cst_create_date,
ca.bdate,
la.cntry
from silver.crm_cust_info as ci
left join  silver.erp_cust_az12 as ca
on ci.cst_key = ca.cid
left join  silver.erp_loc_a101 as la
on ci.cst_key = la.cid
