/*
===============================================================================
Customer Report : gold.report_customers
===============================================================================
Purpose:
    - This report consolidates key customer metrics and behaviors

Highlights:
    1. Gathers essential fields such as names, ages, and transaction details.
	2. Segments customers into categories (VIP, Regular, New) and age groups.
    3. Aggregates customer-level metrics:
	   - total orders
	   - total sales
	   - total quantity purchased
	   - total products
	   - lifespan (in months)
    4. Calculates valuable KPIs:
	    - recency (months since last order)
		- average order value
		- average monthly spend
===============================================================================
*/

-- =============================================================================
-- Create Report: gold.report_customers
-- =============================================================================
IF OBJECT_ID ('gold.report_customers', 'V')IS NOT NULL
	DROP VIEW gold.report_customers;
GO

CREATE VIEW gold.report_customers As

/*---------------------------------------------------------------------------
1) Base Query: Retrieves core columns from tables
---------------------------------------------------------------------------*/
WITH base_query AS(
	select	
		f.order_number,
		f.product_key,
		f.order_date,
		f.sales_amount,
		f.quantity,
		c.customer_key,
		c.customer_number,
		CONCAT(c.first_name,' ',c.last_name) as customer_name,
		DATEDIFF(YEAR, c.birthdate, GETDATE()) as age
	from gold.fact_sales f
	left join gold.dim_customers c
	on f.customer_key = c.customer_key
	where order_date is not null)

/*---------------------------------------------------------------------------
2) Customer Aggregations: Summarizes key metrics at the customer level
---------------------------------------------------------------------------*/
, customer_aggregation AS(
	select 
		customer_key,
		customer_number,
		customer_name,
		age,
		count(distinct order_number) as total_orders,
		sum(sales_amount) as total_sales,
		sum(quantity) as total_quantity,
		count(distinct product_key) as total_products,
		max(order_date) as last_order_date,
		DATEDIFF(month, MIN(order_date),max(order_date)) as lifespan
	from base_query
	group by 
		customer_key,
		customer_number,
		customer_name,
		age)

select
	customer_key,
	customer_number,
	customer_name,
	age,
	CASE WHEN age < 20 THEN 'Under 20'
		 WHEN age BETWEEN 20 AND 29 THEN '20-29'
		 WHEN age BETWEEN 30 AND 39 THEN '30-39'
		 WHEN age BETWEEN 40 AND 49 THEN '40-49'
		 ELSE 'Above 50'
	END as age_group,
	CASE WHEN lifespan >= 12 AND total_sales > 5000 THEN 'VIP'
		 WHEN lifespan >= 12 AND total_sales <= 5000 THEN 'Regular'
		 ELSE 'New' 
	END as customer_segment,
	DATEDIFF(month, last_order_date, GETDATE()) as recency,
	total_orders,
	total_sales,
	total_quantity,
	total_products,
	lifespan,
	--compute average order value (AVO)
	CASE WHEN total_orders = 0 THEN 0
		 ELSE total_sales / total_orders
	END as avg_order_value,
	--compute average monthly spend
	CASE WHEN lifespan = 0 THEN total_sales
		 ELSE total_sales/lifespan
	END as avg_monthly_spend
	from customer_aggregation
	;
