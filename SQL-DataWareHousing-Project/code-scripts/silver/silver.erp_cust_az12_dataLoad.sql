PRINT '>>Truncating Table : silver.erp_cust_az12';
TRUNCATE TABLE silver.erp_cust_az12;
PRINT '>>Inserting into Table : silver.erp_loc_a101';
INSERT INTO silver.erp_cust_az12(CID,BDATE,gen)
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