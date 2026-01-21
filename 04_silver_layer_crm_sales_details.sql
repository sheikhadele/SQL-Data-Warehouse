Data cleaning

--Checking unwanted spaces.

SELECT * from bronze.crm_sales_details
WHERE sls_prd_key != TRIM(sls_ord_num);

--Duplicates and null

SELECT sls_ord_num, COUNT(*) as cn
FROM bronze.crm_sales_details
GROUP BY sls_ord_num
HAVING cn > 1 AND sls_ord_num IS NULL;


--checking if all prd key are common in two tables.

SELECT * FROM bronze.crm_sales_details
WHERE sls_prd_key
NOT IN (SELECT prd_key FROM Silver.crm_prd_info); 

--checking if all customer id are common in both the tables.

SELECT * FROM bronze.crm_sales_details
WHERE sls_cust_id 
NOT IN (SELECT sls_cust_id FROM Silver.crm_cust_info);

--Checking if there any inconsistency in dates, though these are in VARCHAR Form, but checking the number of characters which should be 8 only, year 4, month 2, and day 2.

SELECT * FROM bronze.crm_sales_details
WHERE sls_ship_dt <= 0 OR LENGTH(sls_ship_dt) != 8; 

--Checking if there is dt which is > another supposed dt which should be after the subject date.

SELECT sls_order_dt, sls_ship_dt FROM bronze.crm_sales_details
WHERE sls_ship_dt > sls_due_dt; 

--To check if there is inconsistencies, where the columns does not have proper value.

SELECT DISTINCT sls_price
FROM 
bronze.crm_sales_details
WHERE sls_sales != sls_quantity * sls_price
OR sls_sales IS NULL OR sls_quantity IS NULL OR sls_price IS NULL
OR sls_sales <=0 OR sls_quantity <=0 OR sls_price <=0
ORDER BY sls_sales, sls_quantity, sls_price

To transform the columns with NULL, negative and 0.

SELECT DISTINCT CASE WHEN sls_price =0 OR sls_price IS NULL
THEN sls_sales/NULLIF(sls_quantity,0)
ELSE ABS(sls_price) 
END as sls_price2 , CASE WHEN sls_sales IS NULL OR sls_sales <=0 OR 
sls_sales != sls_quantity * ABS(sls_price) AND sls_price !=0
THEN sls_quantity*ABS(sls_price)
ELSE sls_sales 
END  as sls_sales2, sls_quantity
FROM bronze.crm_sales_details;


This becomes the final query 

SELECT 
sls_ord_num,
    sls_prd_key,
    sls_cust_id,
    CAST(CASE WHEN (sls_order_dt) = 0 OR 
    LENGTH (sls_order_dt) != 8 THEN NULL 
    ELSE sls_order_dt
    END as DATE) as sls_order_dt,
    CAST(sls_ship_dt as DATE) as sls_ship_dt,
    CAST(sls_due_dt as DATE) as sls_due_dt,
    CASE WHEN sls_sales IS NULL OR sls_sales <=0 OR 
sls_sales != sls_quantity * ABS(sls_price) AND sls_price !=0
THEN sls_quantity*ABS(sls_price)
ELSE sls_sales 
END  as sls_sales,
    sls_quantity,
    CASE WHEN sls_price =0 OR sls_price IS NULL
THEN sls_sales/NULLIF(sls_quantity,0)
ELSE ABS(sls_price) 
END as sls_price
FROM bronze.crm_sales_details; 


-------------------------------
Creating table silver.crm_sales_details
-------------------------------


CREATE TABLE silver.crm_sales_details (
sls_ord_num VARCHAR(50),
    sls_prd_key VARCHAR(50),
    sls_cust_id INT,
    sls_order_dt DATE,
    sls_ship_dt DATE,
    sls_due_dt DATE,
    sls_sales VARCHAR(50),
    sls_quantity INT,
    sls_price VARCHAR(50)
);

----------
Inserting data
-----------


INSERT INTO silver.crm_sales_details(
sls_ord_num,
    sls_prd_key,
    sls_cust_id,
    sls_order_dt,
    sls_ship_dt,
    sls_due_dt,
    sls_sales,
    sls_quantity,
    sls_price
)
SELECT 
sls_ord_num,
    sls_prd_key,
    sls_cust_id,
    CAST(CASE WHEN (sls_order_dt) = 0 OR 
    LENGTH (sls_order_dt) != 8 THEN NULL 
    ELSE sls_order_dt
    END as DATE) as sls_order_dt,
    CAST(sls_ship_dt as DATE) as sls_ship_dt,
    CAST(sls_due_dt as DATE) as sls_due_dt,
    CASE WHEN sls_sales IS NULL OR sls_sales <=0 OR 
sls_sales != sls_quantity * ABS(sls_price) AND sls_price !=0
THEN sls_quantity*ABS(sls_price)
ELSE sls_sales 
END  as sls_sales,
    sls_quantity,
    CASE WHEN sls_price =0 OR sls_price IS NULL
THEN sls_sales/NULLIF(sls_quantity,0)
ELSE ABS(sls_price) 
END as sls_price
FROM bronze.crm_sales_details; 

