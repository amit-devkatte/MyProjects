
PRINT '>>Truncating Table : silver.crm_cust_info';
TRUNCATE TABLE silver.crm_cust_info;
PRINT '>>Inserting into Table : silver.crm_cust_info';
INSERT INTO silver.crm_cust_info(
	cst_id,
	cst_key,
	cst_firstname,
	cst_lastname,
	cst_marital_status,
	cst_gndr,
	cst_create_date)

SELECT 
	cst_id,
	cst_key,
	TRIM(cst_firstname)as cst_firstname,
	TRIM(cst_lastname) as cst_lastname,
	CASE WHEN UPPER(TRIM(cst_marital_status)) = 'S' THEN 'Single'
		 WHEN UPPER(TRIM(cst_marital_status)) = 'M' THEN 'Married'
		 ELSE 'n/a'
	END as cst_marital_status, -- Normalise marital status to readable format
	CASE WHEN UPPER(TRIM(cst_gndr)) = 'M' THEN 'Male'
		 WHEN UPPER(TRIM(cst_gndr)) = 'F' THEN 'Female'
		 ELSE 'n/a'
	END as cst_gndr1, -- Normalise the gender values to readable format
	cst_create_date
FROM(
	SELECT *,
		ROW_NUMBER() OVER(PARTITION BY cst_id ORDER BY cst_create_date desc) as flag_latest
	FROM bronze.crm_cust_info
	WHERE cst_id IS NOT NULL  -- This ensures no null values in primary key cst_id column
	)t
WHERE flag_latest =1;  -- This ensures only unique value in primary key cst_id column