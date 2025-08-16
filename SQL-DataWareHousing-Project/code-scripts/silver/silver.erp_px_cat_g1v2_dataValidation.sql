SELECT
id,
cat,
subcat,
maintenance
FROM bronze.erp_px_cat_g1v2;

SELECT *
FROM silver.crm_prd_info;


-- Data check in bronze layer table columns
select *
FROM bronze.erp_px_cat_g1v2
WHERE TRIM(id) !=id OR TRIM(cat)!=cat OR TRIM(subcat) != subcat
	OR TRIM(maintenance) != maintenance
;

SELECT
id
FROM bronze.erp_px_cat_g1v2
WHERE id is null or LEN(id) !=5;

SELECT
id
FROM bronze.erp_px_cat_g1v2
WHERE id NOT IN (
SELECT cat_id FROM silver.crm_prd_info); -- CO_PD is missing

SELECT
distinct cat
FROM bronze.erp_px_cat_g1v2;

SELECT
distinct cat,subcat
FROM bronze.erp_px_cat_g1v2;

SELECT
distinct maintenance
FROM bronze.erp_px_cat_g1v2;

/*=============================================================
	DATA validation in silver layer after data loading
===============================================================*/
select * 
from silver.erp_px_cat_g1v2;





