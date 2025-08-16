/*===========================================================
--checking null or duplicates in primary key column 
=============================================================*/
SELECT * FROM silver.crm_cust_info;

select  cst_id, count(*)
from silver.crm_cust_info
group by cst_id
having count(*) >1 or cst_id is null
;


SELECT *
FROM silver.crm_cust_info
WHERE cst_id = 29466;

-- It shows that duplicates can be removed using cst_create_date column. 
-- where only consider records with latest dates

SELECT * 
FROM(
	SELECT *,
		ROW_NUMBER() OVER(PARTITION BY cst_id ORDER BY cst_create_date desc) as flag_latest
	FROM silver.crm_cust_info
	WHERE cst_id IS NOT NULL  -- This ensures no null values in primary key cst_id column
	)t
WHERE flag_latest =1;  -- This ensures only unique value in primary key cst_id column


/*===========================================================
--checking unwanted spaces in string values
=============================================================*/

select cst_key
from silver.crm_cust_info
where cst_key != trim(cst_key);  --No white spaces

select cst_firstname
from silver.crm_cust_info
where cst_firstname != trim(cst_firstname); -- white spaces present

select cst_lastname
from silver.crm_cust_info
where cst_lastname != trim(cst_lastname); -- white spaces present

select cst_marital_status
from silver.crm_cust_info
where cst_marital_status != trim(cst_marital_status); --No white spaces

select cst_gndr
from silver.crm_cust_info
where cst_gndr != trim(cst_gndr); --No white spaces


--remove white spaces from the string columns
SELECT 
	cst_id,
	cst_key,
	TRIM(cst_firstname)as cst_firstname,
	TRIM(cst_lastname) as cst_lastname,
	cst_marital_status,
	cst_gndr,
	cst_create_date
FROM silver.crm_cust_info;


/*===========================================================
--checking data standardization and consistency
=============================================================*/

SELECT DISTINCT cst_marital_status
FROM silver.crm_cust_info;
--S , M, NULL
SELECT DISTINCT cst_gndr
FROM silver.crm_cust_info;
--NULL, F, M
--We aim to store clear and meaningful values in the table instead of abbreviated terms.

SELECT *
FROM silver.crm_cust_info;