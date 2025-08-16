EXEC silver.load_silver;

/*
=========================================================================
Stored Porcedure : Load Silver Layer (Bronze -> Silver)
=========================================================================
Scipt Purpose:
	This stored procedure perform ETL(Extract, Transform and Load) process 
	to populate the silver schema tables from bronze schema.
Actions performed : 
	-Truncate silver tables before every loading.
	-Inserting transformed and cleaned data from Bronze into Silver tables.
Parameters:
	None
	This stored Procedure does not accept any parameters or return any values.
Usage Example:
	EXEC silver.load_silver;
=========================================================================
*/

CREATE OR ALTER PROCEDURE silver.load_silver AS
BEGIN
	DECLARE @start_time DATETIME, @end_time DATETIME, @batch_start_time DATETIME, @batch_end_time DATETIME;
	BEGIN TRY
		SET @batch_start_time = GETDATE();
		PRINT '============================================================';
		PRINT 'Loading Silver layer data';
		PRINT '============================================================';

		PRINT '------------------------------------------------------------';
		PRINT 'Loading CRM tables data';
		PRINT '------------------------------------------------------------';
		SET @start_time = GETDATE();
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
		SET @end_time = GETDATE();
		PRINT '>> Load Duration : ' + CAST(DATEDIFF(second, @start_time, @end_time) as NVARCHAR) + ' Seconds';
		PRINT '------------------------------------------------------------';
		--=============================================================================
		SET @start_time = GETDATE();
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
		SET @end_time = GETDATE();
		PRINT '>> Load Duration : ' + CAST(DATEDIFF(second, @start_time, @end_time) as NVARCHAR) + ' Seconds';
		PRINT '------------------------------------------------------------';
		--============================================================================
		SET @start_time = GETDATE();
		PRINT '>>Truncating Table : silver.crm_sales_details';
		TRUNCATE TABLE silver.crm_sales_details;
		PRINT '>>Inserting into Table : silver.crm_sales_details';
		INSERT INTO silver.crm_sales_details(
			sls_ord_num,
			sls_prd_key,
			sls_cust_id,
			sls_order_dt,
			sls_ship_dt,
			sls_due_dt,
			sls_sales,
			sls_quantity,
			sls_price
		)
		SELECT 
		sls_ord_num,
		sls_prd_key,
		sls_cust_id,
		CASE WHEN sls_order_dt = 0 OR LEN( sls_order_dt) !=8 THEN NULL
			ELSE CAST (CAST(sls_order_dt AS VARCHAR) AS DATE)
		END sls_order_dt,
		CASE WHEN sls_ship_dt = 0 OR LEN( sls_ship_dt) !=8 THEN NULL
			ELSE CAST (CAST(sls_ship_dt AS VARCHAR) AS DATE)
		END sls_ship_dt,
		CASE WHEN sls_due_dt = 0 OR LEN( sls_due_dt) !=8 THEN NULL
			ELSE CAST (CAST(sls_due_dt AS VARCHAR) AS DATE)
		END sls_due_dt,
		CASE WHEN sls_sales IS NULL or sls_sales <=0 OR sls_sales != sls_quantity * ABS(sls_price)
				THEN sls_quantity * ABS(sls_price)
			 ELSE sls_sales 
		END as sls_sales,
		sls_quantity,
		CASE WHEN sls_price IS NULL or sls_price <=0 
				THEN sls_sales / NULLIF(sls_quantity,0)
			 ELSE sls_price 
		END as sls_price
		FROM bronze.crm_sales_details;
		SET @end_time = GETDATE();
		PRINT '>> Load Duration : ' + CAST(DATEDIFF(second, @start_time, @end_time) as NVARCHAR) + ' Seconds';
		PRINT '------------------------------------------------------------';
		--===========================================================================
	
		PRINT '------------------------------------------------------------';
		PRINT 'Loading ERP tables data';
		PRINT '------------------------------------------------------------';
		SET @start_time = GETDATE();
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
		SET @end_time = GETDATE();
		PRINT '>> Load Duration : ' + CAST(DATEDIFF(second, @start_time, @end_time) as NVARCHAR) + ' Seconds';
		PRINT '------------------------------------------------------------';
		--===========================================================================
	
		SET @start_time = GETDATE();
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
		SET @end_time = GETDATE();
		PRINT '>> Load Duration : ' + CAST(DATEDIFF(second, @start_time, @end_time) as NVARCHAR) + ' Seconds';
		PRINT '------------------------------------------------------------';
		--===========================================================================
	
		SET @start_time = GETDATE();
		PRINT '>>Truncating Table : silver.erp_px_cat_g1v2 ';
		TRUNCATE TABLE silver.erp_px_cat_g1v2 ;
		PRINT '>>Inserting into Table : silver.erp_px_cat_g1v2 ';
		INSERT INTO silver.erp_px_cat_g1v2 
		(id,
		cat,
		subcat,
		maintenance)
		SELECT
		id,
		cat,
		subcat,
		maintenance
		FROM bronze.erp_px_cat_g1v2;
		SET @end_time = GETDATE();
		PRINT '>> Load Duration : ' + CAST(DATEDIFF(second, @start_time, @end_time) as NVARCHAR) + ' Seconds';
		PRINT '------------------------------------------------------------';

		SET @batch_end_time = GETDATE();
		PRINT '===================================================================';
		PRINT 'DATA Loading of Silver Layer is completed';
		PRINT '		-Total Load Duration: '+ CAST (DATEDIFF(second, @batch_start_time, @batch_end_time) as nvarchar) + ' seconds';
		PRINT '===================================================================';
	END TRY
	BEGIN CATCH
		PRINT '===================================================================';
		PRINT 'ERROR OCCURED DURING LOADING SILVER LAYER';
		PRINT 'ERROR MESSAGE : ' + ERROR_MESSAGE();
		PRINT 'ERROR NUMBER : '+ CAST (ERROR_NUMBER() AS NVARCHAR(100));
		PRINT 'ERROR SATET : ' + CAST(ERROR_STATE() AS NVARCHAR(100));
		PRINT '===================================================================';
	END CATCH
END;