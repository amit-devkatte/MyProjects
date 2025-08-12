EXEC bronze.load_bronze;

--Bulk insert with full load
CREATE OR ALTER PROCEDURE bronze.load_bronze AS
	BEGIN
		DECLARE @start_time DATETIME, @end_time DATETIME, @batch_start_time DATETIME, @batch_end_time DATETIME;
		BEGIN TRY
			SET @batch_start_time = GETDATE();
			PRINT '============================================================';
			PRINT 'Loading Bronze layer data';
			PRINT '============================================================';

			PRINT '------------------------------------------------------------';
			PRINT 'Loading CRM tables data';
			PRINT '------------------------------------------------------------';
			
			SET @start_time = GETDATE();
			PRINT '>> Truncating table : bronze.crm_cust_info';
			TRUNCATE TABLE bronze.crm_cust_info;
		
			PRINT '>> Inserting data into table : bronze.crm_cust_info';
			BULK INSERT bronze.crm_cust_info
			FROM 'D:\Amit\SQL\SQL Projects\SQLProject1 _DatawareHouse_ETL_DataAnalysis_Reoprting\datasets\source_crm\cust_info.csv'
			--path needs to be updated as per the source file location
			WITH (
				FIRSTROW =2,
				FIELDTERMINATOR =',',
				TABLOCK 
			);
			SET @end_time = GETDATE();
			PRINT '>> Load Duration : ' + CAST( DATEDIFF(second, @start_time, @end_time) as nvarchar) + ' seconds';
			PRINT '>>----------------------';

			SET @start_time = GETDATE();
			PRINT '>> Truncating table : bronze.crm_prd_info';
			TRUNCATE TABLE bronze.crm_prd_info;
			PRINT '>> Inserting data into table : bronze.crm_prd_info';
			BULK INSERT bronze.crm_prd_info
			FROM 'D:\Amit\SQL\SQL Projects\SQLProject1 _DatawareHouse_ETL_DataAnalysis_Reoprting\datasets\source_crm\prd_info.CSV'
			WITH (
				FIRSTROW = 2,
				FIELDTERMINATOR =',',
				TABLOCK
			);
			SET @end_time = GETDATE();
			PRINT '>> Load Duration : ' +CAST( DATEDIFF(second, @start_time, @end_time) as nvarchar) + ' seconds';
			PRINT '>>----------------------';

			SET @start_time = GETDATE();
			PRINT '>> Truncating table : bronze.crm_sales_details';
			TRUNCATE TABLE bronze.crm_sales_details;
			PRINT '>> Inserting data into table : bronze.crm_sales_details';
			BULK INSERT bronze.crm_sales_details
			FROM 'D:\Amit\SQL\SQL Projects\SQLProject1 _DatawareHouse_ETL_DataAnalysis_Reoprting\datasets\source_crm\sales_details.CSV'
			WITH (
				FIRSTROW = 2,
				FIELDTERMINATOR =',',
				TABLOCK
			);
			SET @end_time = GETDATE();
			PRINT '>> Load Duration : ' +CAST( DATEDIFF(second, @start_time, @end_time) as nvarchar) + ' seconds';
			PRINT '>>----------------------';

			PRINT '------------------------------------------------------------';
			PRINT 'Loading ERP tables data';
			PRINT '------------------------------------------------------------';
			
			SET @start_time = GETDATE();
			PRINT '>> Truncating table : bronze.erp_cust_az12';
			TRUNCATE TABLE bronze.erp_cust_az12;
			PRINT '>> Inserting data into table : bronze.erp_cust_az12';
			BULK INSERT bronze.erp_cust_az12
			FROM 'D:\Amit\SQL\SQL Projects\SQLProject1 _DatawareHouse_ETL_DataAnalysis_Reoprting\datasets\source_erp\cust_az12.CSV'
			WITH (
				FIRSTROW = 2,
				FIELDTERMINATOR =',',
				TABLOCK
			);
			SET @end_time = GETDATE();
			PRINT '>> Load Duration : ' +CAST( DATEDIFF(second, @start_time, @end_time) as nvarchar) + ' seconds';
			PRINT '>>----------------------';

			SET @start_time = GETDATE();
			PRINT '>> Truncating table : bronze.erp_loc_a101';
			TRUNCATE TABLE bronze.erp_loc_a101;
			PRINT '>> Inserting data into table : bronze.erp_loc_a101';
			BULK INSERT bronze.erp_loc_a101
			FROM 'D:\Amit\SQL\SQL Projects\SQLProject1 _DatawareHouse_ETL_DataAnalysis_Reoprting\datasets\source_erp\loc_a101.CSV'
			WITH (
				FIRSTROW = 2,
				FIELDTERMINATOR =',',
				TABLOCK
			);
			SET @end_time = GETDATE();
			PRINT '>> Load Duration : ' +CAST( DATEDIFF(second, @start_time, @end_time) as nvarchar) + ' seconds';
			PRINT '>>----------------------';

			SET @start_time = GETDATE();
			PRINT '>> Truncating table : bronze.erp_px_cat_g1v2';
			TRUNCATE TABLE bronze.erp_px_cat_g1v2;
			PRINT '>> Inserting data into table : bronze.erp_px_cat_g1v2';
			BULK INSERT bronze.erp_px_cat_g1v2
			FROM 'D:\Amit\SQL\SQL Projects\SQLProject1 _DatawareHouse_ETL_DataAnalysis_Reoprting\datasets\source_erp\px_cat_g1v2.CSV'
			WITH (
				FIRSTROW = 2,
				FIELDTERMINATOR =',',
				TABLOCK
			);
			SET @end_time = GETDATE();
			PRINT '>> Load Duration : ' +CAST( DATEDIFF(second, @start_time, @end_time) as nvarchar) + ' seconds';
			PRINT '>>----------------------';

			SET @batch_end_time = GETDATE();
			PRINT '===================================================================';
			PRINT 'DATA Loading of Bronze Layer is completed';
			PRINT '		-Total Load Duration: '+ CAST (DATEDIFF(second, @batch_start_time, @batch_end_time) as nvarchar) + ' seconds';
			PRINT '===================================================================';
		END TRY
		BEGIN CATCH
			PRINT '===================================================================';
			PRINT 'ERROR OCCURED DURING LOADING BRONZE LAYER';
			PRINT 'ERROR MESSAGE :' + ERROR_MESSAGE();
			PRINT 'ERROR NUMBER:' + cast( ERROR_NUMBER() as nvarchar(100));
			PRINT 'ERROR STATE :' + cast(ERROR_STATE() as nvarchar(100));
			PRINT '===================================================================';
		END CATCH
	END;