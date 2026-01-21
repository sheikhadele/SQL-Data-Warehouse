Advanced Data Analysis.

--Change over time (trends): It shows how a measure evolves over time. Like aggregate grouped by date dimension, that will show the trend.

Sales amount based on date, Both year and month separately.

SELECT Year(order_date) as date_year, 
Month(order_date) as date_month,
SUM(sales_amount) AS Total_sum ,
COUNT(DISTINCT customer_key) as total_customers,
SUM(Quantity) as total_quantity
FROM gold.fact_sales
WHERE Year(order_date) is not null
group by Year(order_date), Month(order_date)
ORDER BY Year(order_date);

month and year together with date set to 01.

SELECT DATE_FORMAT(order_date, '%y-%m-01') as order_month,
SUM(sales_amount) AS Total_sum ,
COUNT(DISTINCT customer_key) as total_customers,
SUM(Quantity) as total_quantity
FROM gold.fact_sales
WHERE order_date is not null
group by DATE_FORMAT(order_date, '%y-%m-01')
ORDER BY DATE_FORMAT(order_date, '%y-%m-01');

--Cumulative analysis: Aggregating the data progressively over the time. To know how our business is growing and progressing over the time.

SELECT order_date, total_sales,
SUM(total_sales) OVER(ORDER BY order_date) as Running_total
FROM(
SELECT DATE_FORMAT (order_date, '%Y-%M-01') order_date, 
SUM(sales_amount) as total_sales 
FROM gold.fact_sales
WHERE order_date is not null
GROUP BY DATE_FORMAT(order_date, '%Y-%M-01'))t;


Similarly, can be done year wise of day wise, or week wise as well.

SELECT order_date, total_sales,
SUM(total_sales) OVER(Partition by DATE_FORMAT (order_date, '%Y') ORDER BY order_date) as Running_total
FROM(
SELECT DATE_FORMAT (order_date, '%Y-%m-01') order_date, 
SUM(sales_amount) as total_sales 
FROM gold.fact_sales
WHERE order_date is not null
GROUP BY DATE_FORMAT(order_date, '%Y-%m-01'))t;

Here we have partitioned it by date Yearly.

Also did moving average.

SELECT order_date, total_sales,
SUM (total_sales) OVER(Partition by DATE_FORMAT (order_date, '%Y') ORDER BY order_date) as Running_total,
avg_price,
ROUND(AVG(avg_price) OVER(partition by DATE_FORMAT (order_date, '%Y') order by order_date),2) as moving_average
FROM(
SELECT DATE_FORMAT (order_date, '%Y-%m-01') order_date, 
SUM(sales_amount) as total_sales,
ROUND(AVG(price),2) as avg_price
FROM gold.fact_sales
WHERE order_date is not null
GROUP BY DATE_FORMAT(order_date, '%Y-%m-01'))t
;

--Performance Analysis: We compare the current value with the target value to check the performance of the company. 
e.g we compare the current sale with the avg sale by subtracting, to see how much is the difference, or similarly current year sales with previous year sales. 

Analyse yearly performance of the products by comparing their sales, compare the yearly sales with average sales, and also with previous year sales.

SELECT order_date,
product_name,
total_sales, 
AVG(total_sales) OVER 
(partition by product_name) 
as avg_sales,
total_sales - AVG(total_sales) OVER 
(partition by product_name) as diff_avg,
CASE WHEN total_sales - AVG(total_sales) OVER 
(partition by product_name) > 0 THEN 'Above Average'
WHEN total_sales - AVG(total_sales) OVER 
(partition by product_name) < 0 THEN 'Below Average'
ELSE 'Average'
END as avg_change,
LAG(total_sales) 
OVER(partition by product_name order by order_date) 
as prev_year_sales,
total_sales - LAG(total_sales) 
OVER(partition by product_name order by order_date) as diff_py,
CASE WHEN total_sales - LAG(total_sales) 
OVER(partition by product_name order by order_date) > 0 THEN 'Increasing'
WHEN total_sales - LAG(total_sales) 
OVER(partition by product_name order by order_date) < 0 THEN 'Decreasing'
ELSE 'No Change'
END as py_change

 FROM (

SELECT DATE_FORMAT (order_date, '%Y') as order_date,
dp.product_name as product_name,
SUM(sales_amount) as total_sales
FROM gold.fact_sales fs
JOIN gold.dim_products dp ON fs.product_key = dp.product_key
WHERE order_date is not null
GROUP BY dp.product_name, DATE_FORMAT(order_date, '%Y'))t
order by product_name, order_date;

--Part to Whole Analysis: Analysis of a part how it is performing compared to overall, e.g. to see what category is impacting the business more. 

Which category contribute the most to the overall sales?

SELECT catagory,
total_cat_sales,
SUM(total_cat_sales) OVER () as Overall_sales,
CONCAT(ROUND((total_cat_sales/SUM(total_cat_sales) OVER ())*100,2),'%')  as total_perc 
FROM(
SELECT catagory, 
SUM(sales_amount) as total_cat_sales
FROM gold.fact_sales fs
JOIN gold.dim_products dp ON fs.product_key = dp.product_key
GROUP BY catagory)t;

--Data Segmentation: Here we are creating segments based on a measure and then compare it by another measure. E.g. we have to see how many products have cost that lies in a specific range.

SELECT COUNT(product_key), Cost_range FROM (
SELECT product_key, 
cost,
CASE WHEN cost < 100 THEN 'Below 100'
WHEN cost BETWEEN 100 AND 500 THEN '100-500'
WHEN cost BETWEEN 500 AND 1000 THEN '500-1000'
ELSE 'ABOVE 1000' END as Cost_range
FROM gold.dim_products)t
GROUP BY Cost_range
ORDER BY COUNT(product_key) DESC;

Group customers into three categories based on their spending behaviour, 
VIP – Customers with at least 12 months history and has spend more than 5000$
Regular – Customer with a 12 months of history and has spent less than 5000$.
New – Customer with a less than 12 month history.
and find the total number of customers by each group?

SELECT COUNT(customer_key) as tot_cus,
Cust_group 
FROM(

SELECT customer_key,
total_spending,
life_span,
CASE WHEN life_span > 12 AND total_spending >= 5000 THEN 'VIP Customers'
WHEN life_span > 12 AND total_spending < 5000 THEN 'Regular Customers'
ELSE 'New Customer' END as Cust_Group
FROM(

SELECT dc.customer_key,
MIN(order_date) as old_order,
MAX(order_date) as new_order,
TIMESTAMPDIFF(Month, MIN(order_date), MAX(order_date)) as life_span,
SUM(sales_amount) as total_spending
FROM gold.fact_sales fs
LEFT JOIN gold.dim_customers dc ON 
fs.customer_key = dc.customer_key
WHERE order_date is not null
GROUP BY dc.customer_key)t)y
GROUP BY Cust_Group
order by tot_cus DESC;

--Built Business Report: This is required to do in order to create many business insights for stakeholders.

Customer Report
Purpose:
-	This report consolidates key customer metrics and behaviour.
Highlights:
1.	Gather essential records such as names, ages, and transaction details.
2.	Segments customers in categories (VIP, Regular and New) and age groups.
3.	Aggregates customer level metrics.
- total orders.
- total sales. 
- total quantity purchased.
- total products.
- lifespan (in months).
4. Calculates valuable KPIs: 
- Recency (months since last order).
- average order value.
-average monthly spends.
So first we should start with fact tables and join with dim table to get all the relevant columns.


CREATE VIEW gold.report_customers AS(

WITH base_query as(
SELECT 
f.order_number,
f.product_key,
f.order_date,
f.sales_amount,
f.quantity,
c.customer_key,
c.customer_number,
CONCAT(c.first_name, ' ', c.last_name) as Customer_name,
TIMESTAMPDIFF(YEAR, c.birthdate, CURDATE()) as age
FROM gold.fact_sales f
JOIN gold.dim_customers c ON f.customer_key = c.customer_key
WHERE order_date is not null)

, customer_aggregations AS( 
SELECT 
customer_key,
customer_number,
Customer_name,
age,
COUNT (DISTINCT order_number) as total_orders,
SUM (sales_amount) as total_sales,
SUM (quantity) as total_quantity,
COUNT (DISTINCT product_key) as total_products,
MAX(order_date) as last_order_date,
TIMESTAMPDIFF(Month, MIN(order_date), MAX(order_date)) as life_span
FROM base_query
GROUP BY customer_key,
customer_number,
Customer_name,
age)

SELECT 
customer_key,
customer_number,
Customer_name,
age,
CASE WHEN age < 20 THEN 'Under age'
WHEN age BETWEEN 20 AND 29 THEN '20-29'
WHEN age BETWEEN 30 AND 39 THEN '30-39'
WHEN age BETWEEN 40 AND 49 THEN '40-49'
ELSE 'Above 50'
END as age_group,
CASE WHEN life_span >= 12 AND total_sales >= 5000 THEN 'VIP Customers'
WHEN life_span >= 12 AND total_sales < 5000 THEN 'Regular Customers'
ELSE 'New Customer' END as Cust_Group,
last_order_date,
TIMESTAMPDIFF(month, last_order_date, CURDATE()) as recency,
total_orders,
total_sales,
total_quantity,
total_products,
life_span,
ROUND(CASE WHEN total_sales = 0 THEN 0
ELSE total_sales/total_orders 
END,2) as avg_order_value,
ROUND(CASE WHEN life_span = 0 THEN 0
ELSE total_sales/life_span 
END,2) as avg_monthly_spent
FROM customer_aggregations);
