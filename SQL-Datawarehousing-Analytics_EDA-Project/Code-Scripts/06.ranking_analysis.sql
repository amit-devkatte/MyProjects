/*
===============================================================================
Ranking Analysis
===============================================================================
Purpose:
    - To rank items (e.g., products, customers) based on performance or other metrics.
    - To identify top performers or laggards.

SQL Functions Used:
    - Window Ranking Functions: RANK(), DENSE_RANK(), ROW_NUMBER(), TOP
    - Clauses: GROUP BY, ORDER BY
===============================================================================
*/

-- Which 5 products Generating the Highest Revenue?
select TOP 5
	p.product_name, 
	SUM(s.sales_amount) as revenue
from gold.fact_sales s
left join gold.dim_products p
ON p.product_key = s.product_key
group by p.product_name
order by revenue desc; 

-- Complex but Flexibly Ranking Using Window Functions.
select * 
from(
	select 
		p.product_name, 
		SUM(s.sales_amount) as revenue,
		rank() over(order by SUM(s.sales_amount) desc) as rn 
	from gold.fact_sales s
	left join gold.dim_products p
	ON p.product_key = s.product_key
	group by p.product_name ) t
where rn<=5;
; 

-- What are the 5 worst-performing products in terms of sales?
select * 
from(
	select 
		p.product_name, 
		SUM(s.sales_amount) as revenue,
		rank() over(order by SUM(s.sales_amount) ASC) as rn 
	from gold.fact_sales s
	left join gold.dim_products p
	ON p.product_key = s.product_key
	group by p.product_name ) t
where rn<=5;

-- Find the top 10 customers who have generated the highest revenue
select *
from(
	select 
		c.customer_key,
		c.first_name,
		c.last_name,
		SUM(s.sales_amount) as revenue,
		DENSE_RANK() OVER(ORDER BY SUM(s.sales_amount) DESC) as rn
	from gold.fact_sales s
	left join gold.dim_customers c
	on s.customer_key = c.customer_key
	group by c.customer_key,
			c.first_name,
			c.last_name
	) t
where rn <=10
order by revenue desc;

-- The 3 customers with the fewest orders placed
select *
from(
	select 
			c.customer_key,
			c.first_name,
			c.last_name,
			COUNT(DISTINCT s.order_number) as no_of_orders,
			DENSE_RANK() OVER(ORDER BY COUNT(DISTINCT s.order_number) ASC) as rn
		from gold.fact_sales s
		left join gold.dim_customers c
		on s.customer_key = c.customer_key
		group by c.customer_key,
				c.first_name,
				c.last_name) t
where rn <=3
order by no_of_orders ASC;
