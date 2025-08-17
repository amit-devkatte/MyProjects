
/*==========================================================================
 Exploring dimensions 
============================================================================*/
--Explore all countries our customers come from
select DISTINCT country from gold.dim_customers;

select DISTINCT marital_status from gold.dim_customers;

select DISTINCT gender from gold.dim_customers;


--Explore all categories "The major divisions"
select DISTINCT category from gold.dim_products;
select DISTINCT category,subcategory from gold.dim_products;
select DISTINCT category,subcategory,product_name from gold.dim_products
order by 1,2,3;







