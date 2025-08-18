/*
===============================================================================
Data Segmentation Analysis
===============================================================================
Purpose:
    - To group data into meaningful categories for targeted insights.
    - For customer segmentation, product categorization, or regional analysis.

SQL Functions Used:
    - CASE: Defines custom segmentation logic.
    - GROUP BY: Groups data into segments.
===============================================================================
*/

/*Segment products into cost ranges and count how many products fall into each segment*/
WITH cat_range As(
	select 
		product_key,
		product_name,
		cost,
		CASE WHEN cost < 100 THEN 'Below 100'
			 WHEN cost BETWEEN 100 AND 500 THEN '100-500'
			 WHEN cost BETWEEN 500 AND 1000 THEN '500-1000'
			 ELSE 'Above 1000'
		END as cost_range
	from gold.dim_products)
select 
	cost_range,
	count(product_key) as total_products
from cat_range
group by cost_range
order by total_products desc;

/*
Group customers into three segments based on their spending behavior:
	- VIP: Customers with at least 12 months of history and spending more than €5,000.
	- Regular: Customers with at least 12 months of history but spending €5,000 or less.
	- New: Customers with a lifespan less than 12 months.
And find the total number of customers by each group
*/

select * from gold.dim_customers
select * from gold.fact_sales

WITH cust_category AS (
	select 
		c.customer_key,
		DATEDIFF(MONTH, min(order_date), max(order_date)) life_span,
		SUM(s.sales_amount) as total_spend,
		CASE WHEN DATEDIFF(MONTH, min(s.order_date), max(s.order_date))>= 12 AND SUM(s.sales_amount) > 5000 THEN 'VIP'
			 WHEN DATEDIFF(MONTH, min(s.order_date), max(s.order_date))>= 12 AND SUM(s.sales_amount) <= 5000 THEN 'Regular'
			 --WHEN DATEDIFF(MONTH, min(s.order_date), max(s.order_date))< 12 THEN 'New'
			 ELSE 'New'
		END as customer_group
	from gold.fact_sales s
	left join gold.dim_customers c
	on s.customer_key = c.customer_key
	--where order_date is not null
	group by c.customer_key)

select 
	customer_group,
	count(customer_key) as total_customers
from cust_category
group by customer_group
order by total_customers desc;
	









