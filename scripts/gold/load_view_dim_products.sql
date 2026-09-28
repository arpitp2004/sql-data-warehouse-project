use DataWarehouse
go
create view gold.dim_products as
select 
ROW_NUMBER() over (order by prd_key,prd_start_dt) as surr_key,
pi.prd_id as product_id,
pi.cat_id as category_id,
pi.prd_key as product_key,
pi.prd_nm as product_name,
px.cat as product_category,
px.Subcat as product_subcategory,
px.maintenance,
pi.prd_cost as product_cost,
pi.prd_line as product_line,
pi.prd_start_dt as start_date
from silver.crm_prd_info as pi
left join silver.erp_px_cat_g1v2 as px
on pi.cat_id = px.id
where prd_end_dt is null
