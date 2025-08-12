-- Naming convention for the table names in bronze schema as <source>_<entity>

IF OBJECT_ID ('bronze.crm_cust_info', 'U') IS NOT NULL
	DROP TABLE bronze.crm_cust_info;
--Creating table in bronze schema from crm source folder - cust_info file.
CREATE TABLE bronze.crm_cust_info(
	cst_id int,
	cst_key nvarchar(50),
	cst_firstname nvarchar(50),
	cst_lastname nvarchar(50),
	cst_marital_status nvarchar(50),
	cst_gndr nvarchar(50),
	cst_create_date date
);


IF OBJECT_ID ('bronze.crm_prd_info', 'U') IS NOT NULL
	DROP TABLE bronze.crm_prd_info;
--Creating table in bronze schema from crm source folder - prd_info file.
CREATE TABLE bronze.crm_prd_info(
	prd_id int,
	prd_key nvarchar(50),
	prd_nm nvarchar(100),
	prd_cost int,
	prd_line nvarchar(20),
	prd_start_dt date,
	prd_end_dt date
);


IF OBJECT_ID ('bronze.crm_sales_details', 'U') IS NOT NULL
	DROP TABLE bronze.crm_sales_details;
--Creating table in bronze schema from crm source folder - sales_details file.
CREATE TABLE bronze.crm_sales_details(
	sls_ord_num	 nvarchar(25),
	sls_prd_key	nvarchar(50),
	sls_cust_id	int,
	sls_order_dt int,
	sls_ship_dt	int,
	sls_due_dt int,
	sls_sales int,
	sls_quantity int,
	sls_price int
);


IF OBJECT_ID ('bronze.erp_cust_az12', 'U') IS NOT NULL
	DROP TABLE bronze.erp_cust_az12;
--Creating table in bronze schema from erp source folder - CUST_AZ12 file.
CREATE TABLE bronze.erp_cust_az12(
	CID nvarchar(50),
	BDATE date,
	gen nvarchar(50)
);


IF OBJECT_ID ('bronze.erp_loc_a101', 'U') IS NOT NULL
	DROP TABLE bronze.erp_loc_a101;
CREATE TABLE bronze.erp_loc_a101(
	cid nvarchar(50),
	cntry nvarchar(50)
);


IF OBJECT_ID ('bronze.erp_px_cat_g1v2', 'U') IS NOT NULL
	DROP TABLE bronze.erp_px_cat_g1v2;
CREATE TABLE bronze.erp_px_cat_g1v2(
	id nvarchar(50),
	cat nvarchar(50),
	subcat nvarchar(50),
	maintenance nvarchar(50)
);