Data cleaning.

-Identify duplicate rows:

SELECT cst_id, count(*)
FROM crm_cust_info
GROUP BY cst_id
HAVING count(*) > 1 OR cst_id IS NULL;

 
SELECT * FROM (
SELECT *, 
ROW_NUMBER() OVER (Partition by cst_id order by cst_create_date) as rn
FROM crm_cust_info) t
WHERE rn !=1;

To check unwanted spaces in the strings.

SELECT cst_firstname FROM crm_cust_info
WHERE cst_firstname != TRIM (cst_firstname);

Data standardization and consistency.

SELECT DISTINCT cst_gender
FROM crm_cust_info;

CASE WHEN cst_gender =’M’ THEN ‘MALE’
WHEN cst_gender = ‘F’ THEN ‘FEMALE’
ELSE ‘n/a’


The whole collective query which is cleaned and verified looks like this.

SELECT cst_id, cst_key, TRIM(cst_firstname) as cst_firstname, 
TRIM(cst_lastname) as cst_lastname, 
CASE WHEN UPPER(TRIM(cst_marital_status)) = 'S' THEN 'Single'
    WHEN UPPER (TRIM(cst_marital_status)) = 'M' THEN 'Married'
    ELSE 'n/a'
    END as cst_marital_status,
CASE WHEN UPPER (TRIM(cst_gender)) = 'M' THEN 'Male'
    WHEN UPPER (TRIM(cst_gender)) = 'F' THEN 'Female'
    ELSE 'n/a'
    END as cst_gender,
cst_create_date 
FROM (SELECT *,
ROW_NUMBER() OVER (Partition by cst_id order by cst_create_date) as rn
FROM crm_cust_info
) t
WHERE cst_id IS NOT NULL AND rn = 1;

------------------
CREATE SCHEMA silver;

CREATE TABLE Silver.crm_cust_info (cst_id INT,
    cst_key VARCHAR(50),
    cst_firstname VARCHAR(50),
    cst_lastname VARCHAR(50),
    cst_marital_status VARCHAR(50),
    cst_gender VARCHAR(50),
    cst_create_date DATE);
--------------------------------------
--Then inserting the data.
--------------------------------------

INSERT INTO Silver.crm_cust_info (cst_id, cst_key, 
cst_firstname, cst_lastname, cst_marital_status, 
cst_gender, cst_create_date)

SELECT cst_id, cst_key, TRIM(cst_firstname) as cst_firstname, 
TRIM(cst_lastname) as cst_lastname, 
CASE WHEN UPPER(TRIM(cst_marital_status)) = 'S' THEN 'Single'
    WHEN UPPER (TRIM(cst_marital_status)) = 'M' THEN 'Married'
    ELSE 'n/a'
    END as cst_marital_status,
CASE WHEN UPPER (TRIM(cst_gender)) = 'M' THEN 'Male'
    WHEN UPPER (TRIM(cst_gender)) = 'F' THEN 'Female'
    ELSE 'n/a'
    END as cst_gender,
cst_create_date 
FROM (SELECT *,
ROW_NUMBER() OVER (Partition by cst_id order by cst_create_date DESC) as rn
FROM bronze.crm_cust_info
) t
WHERE cst_id IS NOT NULL AND rn = 1;

