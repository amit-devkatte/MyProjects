--- Data clean & trnasform bronze layer

select sls_ord_num, count(*)
from bronze.crm_sales_details
group by sls_ord_num
having COUNT(*)>1;

select *
from bronze.crm_sales_details
where sls_ord_num IS NULL;
   
select * 
from bronze.crm_sales_details
where sls_prd_key NOT IN(
select prd_key from silver.crm_prd_info)

select *
from bronze.crm_sales_details
where sls_prd_key NOT IN(
select prd_key from silver.crm_prd_info)

select * from INFORMATION_SCHEMA.COLUMNS;

select sls_order_dt
from bronze.crm_sales_details
where sls_order_dt <=0 or sls_order_dt is null;

  --check for invalid dates
select 
NULLIF (sls_order_dt,0) sls_order_dt 
  --NULLIF returns null if two given values are equal else the first expression.
from bronze.crm_sales_details
where sls_order_dt <=0
or len(sls_order_dt) !=8
or sls_order_dt > 20500101 or sls_order_dt < 19000101;

select 
NULLIF (sls_ship_dt,0) sls_ship_dt 
  --NULLIF returns null if two given values are equal else the first expression.
from bronze.crm_sales_details
where sls_ship_dt <=0 or len(sls_ship_dt) !=8
	or sls_ship_dt > 20500101 or sls_ship_dt < 19000101;

select 
NULLIF (sls_due_dt,0) sls_due_dt 
  --NULLIF returns null if two given values are equal else the first expression.
from bronze.crm_sales_details
where sls_due_dt <=0 or len(sls_due_dt) !=8
	or sls_due_dt > 20500101 or sls_due_dt < 19000101;

SELECT *
from bronze.crm_sales_details
where sls_order_dt > sls_due_dt or sls_order_dt > sls_ship_dt;

-- sales = quantity * price
select 
sls_sales,
sls_quantity,
sls_price,
CASE WHEN sls_sales IS NULL or sls_sales <=0 OR sls_sales != sls_quantity * ABS(sls_price)
		THEN sls_quantity * ABS(sls_price)
	 ELSE sls_sales 
END as sls_sales,
CASE WHEN sls_price IS NULL or sls_price <=0 
		THEN sls_sales / NULLIF(sls_quantity,0)
	 ELSE sls_price 
END as sls_price
from bronze.crm_sales_details
where sls_sales != sls_quantity * sls_price
	or sls_sales <=0 or sls_sales is NULL
	or sls_quantity <=0 or sls_quantity is null
	or sls_price <=0 or sls_price is null;

/*--Rules for transformation above columns 
if sales is negative,zero or null then derive it using quantity and price
if price is zero or null then calculate it using sales and quantity
if price is negative the convert it to a positive value

*/
/*===========================================================================
-- DATA VALIDATION IN SILVER LAYER
=============================================================================*/

--- Data clean & trnasform bronze layer

select sls_ord_num, count(*)
from silver.crm_sales_details
group by sls_ord_num
having COUNT(*)>1;

select *
from silver.crm_sales_details
where sls_ord_num IS NULL;
   
select sls_prd_key
from silver.crm_sales_details
where sls_prd_key NOT IN(
select prd_key from silver.crm_prd_info)

select sls_prd_key
from silver.crm_sales_details
where sls_prd_key NOT IN(
select prd_key from silver.crm_prd_info)

select * from INFORMATION_SCHEMA.COLUMNS;

select sls_order_dt
from silver.crm_sales_details
where sls_order_dt is null;

  --check for invalid dates
  
  
SELECT *
from silver.crm_sales_details
where sls_order_dt > sls_due_dt or sls_order_dt > sls_ship_dt;


select 
sls_sales,
sls_quantity,
sls_price
from silver.crm_sales_details
where sls_sales != sls_quantity * sls_price
	or sls_sales <=0 or sls_sales is NULL
	or sls_quantity <=0 or sls_quantity is null
	or sls_price <=0 or sls_price is null;


--Need remove the records where order date is null.
-- discuss with business team for the decision.
SELECT *
from silver.crm_sales_details
where sls_order_dt is null;