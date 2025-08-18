/*
===============================================================================
Performance Analysis (Year-over-Year, Month-over-Month)
===============================================================================
Purpose:
    - To measure the performance of products, customers, or regions over time.
    - For benchmarking and identifying high-performing entities.
    - To track yearly trends and growth.

SQL Functions Used:
    - LAG(): Accesses data from previous rows.
    - AVG() OVER(): Computes average values within partitions.
    - CASE: Defines conditional logic for trend analysis.
===============================================================================
*/

/* Analyze the yearly performance of products by comparing their sales 
to both the average sales performance of the product and the previous year's sales */

WITH yearly_product_sales AS(
	select
		YEAR(s.order_date) as order_year,
		p.product_name,
		SUM(s.sales_amount) as current_sales
	from gold.fact_sales s
	left join gold.dim_products p
	on s.product_key = p.product_key
	where order_date is not null
	group by YEAR(s.order_date),
		p.product_name)
select
	order_year,
	product_name,
	current_sales,
	AVG(current_sales) OVER(PARTITION BY product_name) avg_sales,
	current_sales - AVG(current_sales) OVER(PARTITION BY product_name) as diff_avg_sales,
	CASE WHEN current_sales - AVG(current_sales) OVER(PARTITION BY product_name) > 0 THEN 'Above'
		 WHEN current_sales - AVG(current_sales) OVER(PARTITION BY product_name) < 0 THEN 'Below'
		 ELSE 'Average'
	END as avg_change,
	LAG(current_sales) OVER(PARTITION BY product_name ORDER BY order_year) py_sales,
	current_sales -LAG(current_sales) OVER(PARTITION BY product_name ORDER BY order_year) as diff_py,
	CASE WHEN current_sales -LAG(current_sales) OVER(PARTITION BY product_name ORDER BY order_year) > 0 THEN 'Increase'
		 WHEN current_sales -LAG(current_sales) OVER(PARTITION BY product_name ORDER BY order_year) < 0 THEN 'Decrease'
		 ELSE 'No Change'
	END as py_change
from yearly_product_sales
order by 2,1;































