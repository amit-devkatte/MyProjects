
/*==========================================================================
--Date exploration
============================================================================*/

--find the youngest and the oldest customer
select 
	max(birthdate) as yougest_birthdate,
	datediff( year, max(birthdate ),getdate()) youngest_customer_age,
	min(birthdate) as oldest_birthdate,
	datediff( year, min( birthdate ),getdate()) oldest_customer_age
from gold.dim_customers;

--find the date of the first and last order
select min(order_date) first_date,
	   max(order_date) last_date,
	   datediff(month, min(order_date), max(order_date)) as order_range_months
from gold.fact_sales;