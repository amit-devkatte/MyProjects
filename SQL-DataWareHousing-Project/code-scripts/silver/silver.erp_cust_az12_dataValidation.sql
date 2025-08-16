
---Transformation steps in columns
select 
CASE WHEN CID like 'NAS%' THEN SUBSTRING(cid, 4,len(cid))
	ELSE CID
END as cid,
CASE WHEN BDATE > GETDATE() THEN NULL
	 ELSE BDATE 
END as BDATE,
CASE WHEN UPPER(TRIM(gen)) IN ('M', 'MALE') THEN 'Male'
	 WHEN UPPER(TRIM(gen)) IN ('F', 'FEMALE') THEN 'Female'
	 ELSE 'n/a'
END as gen1
from bronze.erp_cust_az12;



-- Data checking for columns
select 
CID,
BDATE,
gen
from bronze.erp_cust_az12;

select TOP 100 *
from silver.crm_cust_info;

select 
MIN(bdate),
MAX(bdate)
from bronze.erp_cust_az12

select 
BDATE
from bronze.erp_cust_az12
where BDATE > GETDATE() -- Future dates. Invalid


select distinct gen
from bronze.erp_cust_az12; -- inconsistent data

--Data validation silver layer
select * 
from silver.erp_cust_az12;

select cid
from silver.erp_cust_az12
where LEN(cid) != 10;

select BDATE
from silver.erp_cust_az12
where BDATE > GETDATE();

select distinct gen
from silver.erp_cust_az12;