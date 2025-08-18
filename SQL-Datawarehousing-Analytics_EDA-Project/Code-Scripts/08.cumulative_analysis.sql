/*
===============================================================================
Cumulative Analysis
===============================================================================
Purpose:
    - To calculate running totals or moving averages for key metrics.
    - To track performance over time cumulatively.
    - Useful for growth analysis or identifying long-term trends.

SQL Functions Used:
    - Window Functions: SUM() OVER(), AVG() OVER()
===============================================================================
*/

-- Calculate the total sales per month and the running total of sales over time 
select 
	order_date,
	total_sales,
	SUM(total_sales) OVER(order by order_date) as running_total_sales,
	AVG(avg_price) OVER(order by order_date) as moving_avg_price
from(
	select 
		DATETRUNC(month,order_date) as order_date,
		SUM(sales_amount) as total_sales,
		AVG(price) as avg_price
	from gold.fact_sales
	where order_date is not null
	group by DATETRUNC(month,order_date)
	)t;


-- partition by year so that every year running total and moving avg reset at first month
select 
	order_date,
	total_sales,
	SUM(total_sales) OVER(partition by YEAR(order_date) order by order_date) as running_total_sales,
	AVG(avg_price) OVER(partition by YEAR(order_date) order by order_date) as moving_avg_price
from(
	select 
		DATETRUNC(month,order_date) as order_date,
		SUM(sales_amount) as total_sales,
		AVG(price) as avg_price
	from gold.fact_sales
	where order_date is not null
	group by DATETRUNC(month,order_date)
	)t;