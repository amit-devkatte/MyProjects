PRINT '>>Truncating Table : silver.erp_loc_a101';
TRUNCATE TABLE silver.erp_loc_a101;
PRINT '>>Inserting into Table : silver.erp_loc_a101';
INSERT INTO silver.erp_loc_a101(cid,cntry)
select 
replace (cid, '-', '') as cid,
CASE WHEN TRIM(cntry) IN ('DE', 'Germany') THEN 'Germany'
	 WHEN TRIM(cntry) IN ('USA', 'US','United States') THEN 'USA'
	 WHEN TRIM(cntry) IS NULL OR TRIM(cntry) ='' THEN 'n/a'
	 ELSE TRIM(cntry)
END as cntry
FROM bronze.erp_loc_a101;

