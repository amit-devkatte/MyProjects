select *
from bronze.erp_loc_a101


select cid
from bronze.erp_loc_a101
where cid not in (select cst_key from silver.crm_cust_info)
-- findings the '-' in cid column which is not present in erp_cust_az12

select distinct cntry
from bronze.erp_loc_a101

-- cntry column contains different entries for same country like (DE, Germany)
-- (USA, United States, US) and  empty spaces and null values


--Transformation steps
select 
DISTINCT cntry,
CASE WHEN cntry IN ('DE', 'Germany') THEN 'Germany'
	 WHEN cntry IN ('USA', 'US','United States') THEN 'USA'
	 WHEN cntry IS NULL OR TRIM(cntry) ='' THEN 'n/a'
	 ELSE cntry
END as cntry
FROM bronze.erp_loc_a101

select replace (cid, '-', '') as cid
from bronze.erp_loc_a101


--Data validation bronze
select * from (
select replace (cid, '-', '') as cid
from bronze.erp_loc_a101) t
where cid not in (select cst_key from silver.crm_cust_info)

select 
DISTINCT 
CASE WHEN cntry IN ('DE', 'Germany') THEN 'Germany'
	 WHEN cntry IN ('USA', 'US','United States') THEN 'USA'
	 WHEN cntry IS NULL OR TRIM(cntry) ='' THEN 'n/a'
	 ELSE cntry
END as cntry
FROM bronze.erp_loc_a101

/*==========================================================
-- DATA quality checks for silver layer after data loading
============================================================*/

select *
from silver.erp_loc_a101
where cid not in (select cst_key from silver.crm_cust_info)

select 
DISTINCT cntry
FROM silver.erp_loc_a101