/*
===============================================================================
Part-to-Whole Analysis
===============================================================================
Purpose:
    - To compare performance or metrics across dimensions or time periods.
    - To evaluate differences between categories.
    - Useful for A/B testing or regional comparisons.

SQL Functions Used:
    - SUM(), AVG(): Aggregates values for comparison.
    - Window Functions: SUM() OVER() for total calculations.
===============================================================================
*/
-- Which categories contribute the most to overall sales?

WITH cat_sales AS(
	select 
		p.category,
		SUM(s.sales_amount) as total_sales
	from gold.fact_sales s
	left join gold.dim_products p
	on s.product_key = p.product_key
	group by p.category)

select 
	category,
	total_sales,
	SUM(total_sales) OVER() as overall_sales,
	CONCAT(ROUND(cast(total_sales as float)* 100 / SUM(total_sales) OVER(),2),'%') percent_contribution
from cat_sales
order by total_sales desc;




