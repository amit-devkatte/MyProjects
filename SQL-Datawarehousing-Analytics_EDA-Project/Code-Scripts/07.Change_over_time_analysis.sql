/*
===============================================================================
Change Over Time Analysis
===============================================================================
Purpose:
    - To track trends, growth, and changes in key metrics over time.
    - For time-series analysis and identifying seasonality.
    - To measure growth or decline over specific periods.

SQL Functions Used:
    - Date Functions: DATEPART(), DATETRUNC(), FORMAT()
    - Aggregate Functions: SUM(), COUNT(), AVG()
===============================================================================
*/

-- Analyse sales performance over time
-- Quick Date Functions
--by year
select
	YEAR(order_date) as order_year,
	SUM(sales_amount) as total_sales,
	count(distinct customer_key) as total_customers,
	count(quantity) as total_quantity
from gold.fact_sales
where order_date is not null
group by YEAR(order_date)
order by order_year;

-- by month
select
	YEAR(order_date) as order_year,
	MONTH(order_date) as order_month,
	SUM(sales_amount) as total_sales,
	count(distinct customer_key) as total_customers,
	count(quantity) as total_quantity
from gold.fact_sales
where order_date is not null
group by YEAR(order_date), MONTH(order_date)
order by order_year,order_month;

--DATETRUNC()
select
	DATETRUNC(month,order_date) as order_date,
	SUM(sales_amount) as total_sales,
	count(distinct customer_key) as total_customers,
	count(quantity) as total_quantity
from gold.fact_sales
where order_date is not null
group by DATETRUNC(month,order_date)
order by order_date;

--FORMAT()
select
	FORMAT(order_date, 'yyyy-MMM') as order_date,
	SUM(sales_amount) as total_sales,
	count(distinct customer_key) as total_customers,
	count(quantity) as total_quantity
from gold.fact_sales
where order_date is not null
group by FORMAT(order_date, 'yyyy-MMM')
order by order_date;