select prd_id,
count(*)
from bronze.crm_prd_info
group by prd_id
having count(*) != 1 or prd_id is null

select prd_nm
from bronze.crm_prd_info
where prd_nm != TRIM(prd_nm)

select prd_cost
from bronze.crm_prd_info
where prd_cost<0 or prd_cost is null

select distinct prd_line
from bronze.crm_prd_info

select * 
from bronze.crm_prd_info
where prd_start_dt > prd_end_dt
