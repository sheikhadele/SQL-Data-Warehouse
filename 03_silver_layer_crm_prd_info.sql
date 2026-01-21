CLEANING AND FILTERING.

--Checking duplicates and NULL

SELECT prd_id, COUNT(*) as cn
FROM bronze.crm_prd_info
GROUP BY prd_id
HAVING cn > 1 AND prd_id = NULL;


REPLACE(SUBSTRING(prd_key,1,5), '-','_') as prd_cat,
SUBSTRING(prd_key,7, LENGTH(prd_key)) as prd_key


The above query is used to SUBSTRING the column i.e. Prd_key which is a combination of prd_catagory and product_key also present in other tables.

To identify unwanted spaces in column prd_nm;

SELECT prd_nm FROM bronze.crm_prd_info
WHERE prd_nm != TRIM(prd_nm);

Checking another column prd_cost for NULL or negative values.

SELECT prd_cost FROM bronze.crm_prd_info
WHERE prd_cost <0 OR prd_cost;

Null values replaced by a '0'.

CASE WHEN prd_cost IS NULL THEN '0' 
ELSE prd_cost
END as prd_cost, 
Or
IFNULL (prd_cost, 0) AS prd_cost;

Full form given to prd_line M, R, S, R and NULL as n/a.

CASE WHEN UPPER(TRIM(prd_line)) = 'M' THEN 'Mountain'
WHEN UPPER(TRIM(prd_line)) = 'R' THEN 'Road'
WHEN UPPER(TRIM(prd_line)) = 'S' THEN 'Other Sales'
WHEN UPPER(TRIM(prd_line)) = 'T' THEN 'Touring'
ELSE 'n/a'
END as Prd_line

To see if start date is > end date which shouldn’t be the case.

SELECT * from  bronze.crm_prd_info
WHERE prd_start_date > prd_end_date;

The data has prd_start_date > prd_end_date, hence end date is created from start date of the next row for the same pro_key keeping an interval of 1 day between last end date and next start date.

CAST(DATE_SUB(LEAD(prd_start_date) OVER(PARTITION BY prd_key ORDER BY prd_start_date ASC), INTERVAL 1 DAY) as DATE) as prd_end_date;


Then the complete query becomes;

SELECT prd_id, 
REPLACE(SUBSTRING(prd_key,1,5), '-','_') as prd_cat,
SUBSTRING(prd_key,7, LENGTH(prd_key)) as prd_key,
prd_nm,
IFNULL (prd_cost, 0) AS prd_cost,
CASE WHEN UPPER(TRIM(prd_line)) = 'M' THEN 'Mountain'
WHEN UPPER(TRIM(prd_line)) = 'R' THEN 'Road'
WHEN UPPER(TRIM(prd_line)) = 'S' THEN 'Other Sales'
WHEN UPPER(TRIM(prd_line)) = 'T' THEN 'Touring'
ELSE 'n/a'
END as Prd_line,
prd_start_date, 
CAST(DATE_SUB(LEAD(prd_start_date) OVER(PARTITION BY prd_key ORDER BY prd_start_date ASC), INTERVAL 1 DAY) as DATE) as prd_end_date
FROM bronze.crm_prd_info;

---------------------------------
Creating Table silver.crm_prd_info
---------------------------------

CREATE TABLE silver.crm_prd_info(
    prd_id INT,
    cat__id VARCHAR(50),
    prd_key VARCHAR(50),
    prd_nm VARCHAR(50),
    prd_cost INT,
    prd_line VARCHAR(50),
    prd_start_date DATE,
    prd_end_date DATE
);

--------------------------
Then inserting data
--------------------------

INSERT INTO silver.crm_prd_info(
    prd_id,
    cat__id,
    prd_key,
    prd_nm,
    prd_cost,
    prd_line,
    prd_start_date,
    prd_end_date)


SELECT prd_id, 
REPLACE(SUBSTRING(prd_key,1,5), '-','_') as prd_cat,
SUBSTRING(prd_key,7, LENGTH(prd_key)) as prd_key,
prd_nm,
IFNULL (prd_cost, 0) AS prd_cost,
CASE WHEN UPPER(TRIM(prd_line)) = 'M' THEN 'Mountain'
WHEN UPPER(TRIM(prd_line)) = 'R' THEN 'Road'
WHEN UPPER(TRIM(prd_line)) = 'S' THEN 'Other Sales'
WHEN UPPER(TRIM(prd_line)) = 'T' THEN 'Touring'
ELSE 'n/a'
END as Prd_line,
prd_start_date, 
CAST(DATE_SUB(LEAD(prd_start_date) OVER(PARTITION BY prd_key ORDER BY prd_start_date ASC), INTERVAL 1 DAY) as DATE) as prd_end_date
FROM bronze.crm_prd_info;
