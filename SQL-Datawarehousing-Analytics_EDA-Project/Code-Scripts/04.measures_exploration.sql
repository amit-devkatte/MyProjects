/*==========================================================================
 Exploring measures
============================================================================*/

--Find the total sales
select SUM(sales_amount) as total_sales from gold.fact_sales;

--Find how many items are sold
select SUM(quantity) as total_items from gold.fact_sales;

--Find the average selling price
select avg( price ) as average_price from gold.fact_sales

--Find the total number of orders
select count(order_number) from gold.fact_sales;
select count(DISTINCT order_number) from gold.fact_sales;

--Find the total number of products
select count(DISTINCT product_number) as total_products from gold.dim_products;

--Find the total number of customers
select count(DISTINCT customer_key) as total_customers from gold.dim_customers;

--Find the total number of customers that has placed an order
select count(distinct customer_key) Ordered_customers_number from gold.fact_sales;

--Generate a report that shows all key metrics of the business
select 'Total_sales' as measure_name, SUM(sales_amount) as measure_value from gold.fact_sales
UNION ALL
select 'Total Quantity' ,SUM(quantity) from gold.fact_sales
UNION ALL
select 'Average_price', avg( price ) from gold.fact_sales
UNION ALL
select 'Total number of Orders',count(DISTINCT order_number) from gold.fact_sales
UNION ALL
select 'Total number of Products', count(DISTINCT product_number) from gold.dim_products
UNION ALL
select 'Total number of Customers', count(DISTINCT customer_key) from gold.dim_customers
UNION ALL
select 'Total number of Customers ordered',count(distinct customer_key) from gold.fact_sales;
