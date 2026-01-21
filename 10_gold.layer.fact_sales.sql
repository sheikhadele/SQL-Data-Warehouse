Data integration.
Creating Fact table by joining multiple tables.

The final query after giving friendly names. The two columns pr.product_key and cu.Customer_key are obtained from joined table and replaced the actual columns of the main table in order to generate a relation ship with other tables.

SELECT  
    sls_ord_num AS order_number,
    pr.product_key,
    cu.Customer_key,
    sls_order_dt AS order_date,
    sls_ship_dt AS shipping_date,
    sls_due_dt AS due_date,
    sls_sales AS sales_amount,
    sls_quantity AS quantity,
    sls_price AS price
FROM silver.crm_sales_details sd
JOIN  gold.dim_products pr
ON sd.sls_prd_key = pr.product_number
JOIN gold.dim_customers cu
ON sd.sls_cust_id = cu.customer_id;

-----------------------------------------
Creating View
---------------------------------------

CREATE VIEW gold.fact_sales AS
SELECT  
    sls_ord_num AS order_number,
    pr.product_key,
    cu.Customer_key,
    sls_order_dt AS order_date,
    sls_ship_dt AS shipping_date,
    sls_due_dt AS due_date,
    sls_sales AS sales_amount,
    sls_quantity AS quantity,
    sls_price AS price
FROM silver.crm_sales_details sd
JOIN  gold.dim_products pr
ON sd.sls_prd_key = pr.product_number
JOIN gold.dim_customers cu
ON sd.sls_cust_id = cu.customer_id;
