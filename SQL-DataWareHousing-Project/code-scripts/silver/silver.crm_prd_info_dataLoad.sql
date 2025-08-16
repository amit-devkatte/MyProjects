PRINT '>>Truncating Table : silver.crm_prd_info';
TRUNCATE table silver.crm_prd_info;
PRINT '>>Inserting into Table : silver.crm_prd_info';
INSERT INTO silver.crm_prd_info(
	prd_id,
	cat_id,
	prd_key,
	prd_nm,
	prd_cost,
	prd_line,
	prd_start_dt,
	prd_end_dt)
select 
	prd_id,
	REPLACE( SUBSTRING(prd_key,1,5),'-','_') as cat_id,
	SUBSTRING(prd_key,7,LEN(prd_key)) as prd_key,
	prd_nm,
	ISNULL(prd_cost,0) as prd_cost,
	CASE UPPER(TRIM(prd_line))
		WHEN 'M' THEN 'Mountain' 
		WHEN 'R' THEN 'Road' 
		WHEN 'S' THEN 'Other Sales' 
		WHEN 'T' THEN 'Touring'
		ELSE 'n/a'
	END as prd_line,
	prd_start_dt,
	DATEADD(day,-1,LEAD(prd_start_dt) over(partition by prd_key order by prd_start_dt)) as prd_end_dt
from bronze.crm_prd_info;
