

---check for primary columns uniqueness and nulls

select prd_id, COUNT(*)
from bronze.crm_prd_info
where prd_id is not null
group by prd_id
having COUNT(*) >1; -- no duplicate as well as no nulls


select prd_key, COUNT(*)
from bronze.crm_prd_info
group by prd_key
having COUNT(*) >1; ---multiple duplicate rows due to prd start date and end date values.

-- check unwanted spaces in string columns

select prd_key
from bronze.crm_prd_info
where prd_key != TRIM(prd_key);

select prd_nm
from bronze.crm_prd_info
where prd_nm != TRIM(prd_nm);

select prd_cost
from bronze.crm_prd_info
where prd_cost is null or prd_cost <0; --replace null with 0

select distinct prd_line
from bronze.crm_prd_info


--checking start date and end date columns
select prd_start_dt, prd_end_dt
from bronze.crm_prd_info
where prd_start_dt < prd_end_dt; -- end date is smaller than start date. need correction.

-- updating start date and end date
select 
	prd_id,
	prd_key,
	prd_nm,
	prd_start_dt,
	--prd_end_dt,
	DATEADD(day,-1,LEAD(prd_start_dt) over(partition by prd_key order by prd_start_dt)) as prd_end_dt
from bronze.crm_prd_info
where prd_key IN ('AC-HE-HL-U509-R','AC-HE-HL-U509');