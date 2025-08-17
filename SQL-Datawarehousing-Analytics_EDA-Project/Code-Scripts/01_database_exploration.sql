-- Database exploration

select * from gold.dim_customers;
select * from gold.dim_products;
select * from gold.fact_sales;

-- Exploring database and schema and tables , columns
select * from INFORMATION_SCHEMA.TABLES;

select * from INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'dim_customers';