Data Integration
Creating dimension table by joining multiple tables.

--Joining two tables.

SELECT cst_id,
cst_key,
cst_firstname,
cst_lastname,
cst_marital_status,
cst_gender,
cst_create_date,
ca.BDATE,
ca.GEN,
la.CNTRY 
FROM silver.crm_cust_info ci
LEFT JOIN silver.erp_cust_az12 ca
ON ci.cst_key = ca.cid
LEFT JOIN Silver.erp_LOC_A101 la
ON ci.cst_key = la.cid;

--checking duplicates

SELECT cst_id, COUNT(cst_id)
FROM (SELECT cst_id,
cst_key,
cst_firstname,
cst_lastname,
cst_marital_status,
cst_gender,
cst_create_date,
ca.BDATE,
ca.GEN,
la.CNTRY 
FROM silver.crm_cust_info ci
LEFT JOIN silver.erp_cust_az12 ca
ON ci.cst_key = ca.cid
LEFT JOIN Silver.erp_LOC_A101 la
ON ci.cst_key = la.cid) dds
GROUP BY cst_id
HAVING count(cst_id)>1;


--checking GEN column

SELECT DISTINCT ca.GEN, cst_gender FROM silver.crm_cust_info ci
LEFT JOIN silver.erp_cust_az12 ca
ON ci.cst_key = ca.cid
LEFT JOIN Silver.erp_LOC_A101 la
ON ci.cst_key = la.cid
ORDER BY 1,2;

The result shows inconsistent data in the table since gender is two columns, hence we need to integrate the data.

CASE WHEN cst_gender != 'n/a' THEN cst_gender
    ELSE COALESCE(GEN, 'n/a')
    END as GENDER;

---------------------------
Creating gold schema
--------------------------

CREATE SCHEMA gold;

The final query after data integration and giving friendly names to the columns, and also adding surrogate key as customer_key.



SELECT 
ROW_NUMBER() OVER(order by cst_id) as Customer_key,
cst_id as customer_id,
cst_key as customer_number,
cst_firstname as first_name,
cst_lastname as last_name,
la.CNTRY as Country,
cst_marital_status as marital_status,
CASE WHEN cst_gender != 'n/a' THEN cst_gender
    ELSE COALESCE(ca.GEN, 'n/a')
    END as gender,
ca.BDATE as birthdate,
cst_create_date as create_date
FROM silver.crm_cust_info ci
LEFT JOIN silver.erp_cust_az12 ca
ON ci.cst_key = ca.cid
LEFT JOIN Silver.erp_LOC_A101 la
ON ci.cst_key = la.cid;

------------------------------
Creating a VIEW in gold schema
------------------------------

CREATE VIEW gold.dim_customers AS(
SELECT 
ROW_NUMBER() OVER(order by cst_id) as Customer_key,
cst_id as customer_id,
cst_key as customer_number,
cst_firstname as first_name,
cst_lastname as last_name,
la.CNTRY as Country,
cst_marital_status as marital_status,
CASE WHEN cst_gender != 'n/a' THEN cst_gender
    ELSE COALESCE(ca.GEN, 'n/a')
    END as gender,
ca.BDATE as birthdate,
cst_create_date as create_date
FROM silver.crm_cust_info ci
LEFT JOIN silver.erp_cust_az12 ca
ON ci.cst_key = ca.cid
LEFT JOIN Silver.erp_LOC_A101 la
ON ci.cst_key = la.cid);
