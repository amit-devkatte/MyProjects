/*
==================================================================
Creating Database and Schemas for DataAnalytics_EDA project
==================================================================
The scripts perform below tasks
	- create a database 'DatawarehousingAnalytics'
	- checks : if database exists then drop and recreate
	- create a schema 'gold'

!!Warning : Running this scripts will drop the entire database if exists.
			All data in the database will be permanently deleted.
			Proceed with caution and ensure to have proper backup before
			running the script.

--------------------------------------------------------------------*/

use master;
GO

-- drop and recreate the 'DatawarehouseAnalytics' database
IF EXISTS (SELECT 1 FROM sys.databases WHERE name = 'DatawarehouseAnalytics')
BEGIN
	ALTER DATABASE DatawarehouseAnalytics SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
	DROP DATABASE DatawarehouseAnalytics;
END;
GO

-- Create the 'DataWarehouseAnalytics' database
CREATE DATABASE DatawarehouseAnalytics;
GO

USE DatawarehouseAnalytics;
GO

-- Create the 'gold' schema
CREATE SCHEMA gold;
GO

CREATE TABLE gold.dim_customers(
	customer_key int,
	customer_id int,
	customer_number nvarchar(50),
	first_name nvarchar(50),
	last_name nvarchar(50),
	country nvarchar(40),
	marital_status nvarchar(25),
	gender nvarchar(20),
	birthdate date,
	create_date date
);
GO

CREATE TABLE gold.dim_products(
	product_key int,
	product_id int,
	product_number nvarchar(50),
	product_name nvarchar(50),
	category_id nvarchar(50),
	category nvarchar(50),
	subcategory nvarchar(50),
	maintenance nvarchar(50),
	cost int,
	product_line nvarchar(50),
	start_date date
);
GO

CREATE TABLE gold.fact_sales(
	order_number nvarchar(50),
	product_key int,
	customer_key int,
	order_date date,
	shipping_date date,
	due_date date,
	sales_amount int,
	quantity int,
	price int
);
GO

TRUNCATE TABLE gold.dim_customers;
GO

BULK INSERT gold.dim_customers
FROM 'D:\Amit\SQL\SQL Projects\SQLProject2_DataAnalytics_EDA\Dataset\gold.dim_customers.csv'
WITH (
	FIRSTROW = 2,
	FIELDTERMINATOR = ',',
	TABLOCK
);
GO

TRUNCATE TABLE gold.dim_products;
GO

BULK INSERT gold.dim_products
FROM 'D:\Amit\SQL\SQL Projects\SQLProject2_DataAnalytics_EDA\Dataset\gold.dim_products.csv'
WITH(
	FIRSTROW = 2,
	FIELDTERMINATOR = ',',
	TABLOCK
);
GO

TRUNCATE TABLE gold.fact_sales;
GO

BULK INSERT gold.fact_sales
FROM 'D:\Amit\SQL\SQL Projects\SQLProject2_DataAnalytics_EDA\Dataset\gold.fact_sales.csv'
WITH (
	FIRSTROW = 2,
	FIELDTERMINATOR = ',',
	TABLOCK
);
GO
